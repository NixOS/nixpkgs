{ config, lib, ... }:

with builtins;

let

  cfg = config.flyingcircus;

  stripNetmask = addr : elemAt (lib.splitString "/" addr) 0;

  # choose the correct iptables version for addr
  iptables = addr: if is_ip4 addr then "iptables" else "ip6tables";

  get_prefix_length = network:
    lib.toInt (elemAt (lib.splitString "/" network) 1);

  is_ip4 = address_or_network:
    length (lib.splitString "." address_or_network) == 4;

  is_ip6 = address_or_network:
    length (lib.splitString ":" address_or_network) > 1;

  _ip_interface_configuration = networks: network:
      map (
        ip_address: {
          address = ip_address;
          prefixLength = get_prefix_length network;
        })
       (getAttr network networks);

  get_ip_configuration = version_filter: networks:
    lib.concatMap
      (_ip_interface_configuration networks)
      (filter version_filter (attrNames networks));


  get_interface_ips = networks:
    { ip4 = get_ip_configuration is_ip4 networks;
      ip6 = get_ip_configuration is_ip6 networks;
    };

  get_interface_configuration = interfaces: interface_name:
    { name = "eth${interface_name}";
      value = get_interface_ips (getAttr interface_name interfaces).networks;
    };

  get_network_configuration = interfaces:
    listToAttrs
      (map
       (get_interface_configuration interfaces)
       (attrNames interfaces));

  # Policy routing

  routing_priorities = {
    fe = 20;
    srv = 30;
  };

  get_policy_routing_for_interface = interfaces: interface_name:
    map (network: {
       priority = lib.attrByPath [ interface_name ] 100 routing_priorities;
       network = network;
       interface = interface_name;
       gateway = getAttr network (getAttr interface_name interfaces).gateways;
       addresses = getAttr network (getAttr interface_name interfaces).networks;
       family = if (is_ip4 network) then "4" else "6";
     }) (attrNames interfaces.${interface_name}.gateways);


  # Those policy routing rules ensure that we can run multiple IP networks
  # on the same ethernet segment. We will still use the router but we avoid,
  # for example, that we send out to an SRV network over the FE interface
  # which may confuse the sender trying to reply to us on the FE interface
  # or even filtering the traffic when the other interface has a shared
  # network.
  #
  # The address rules ensure that we send out over the interface that belongs
  # to the connection that a packet belongs to, i.e. established flows.
  # (Address rules only apply to networks we have an address for.)
  #
  # The network rules ensure that we packets over the best interface where
  # the target network is reachable if we haven't decided the originating
  # address, yet.
  # (Network rules apply for all networks on the segment, even if we do not
  # have an address for it.)

  render_policy_routing_rule = ruleset:
    let
      render_address_rules =
        lib.concatMapStrings
          (address: "ip -${ruleset.family} rule add priority ${toString (ruleset.priority)} from ${address} lookup ${ruleset.interface}")
          ruleset.addresses;
      render_gateway_rule =
        if (length ruleset.addresses) > 0 then
          "ip -${ruleset.family} route add default via ${ruleset.gateway} table ${ruleset.interface} || true"
        else
          "";
    in
    ''
    ${render_address_rules}
    ip -${ruleset.family} rule add priority ${toString (ruleset.priority)} from all to ${ruleset.network} lookup ${ruleset.interface}
    ${render_gateway_rule}
    '';

  get_policy_routing = interfaces:
    map
      render_policy_routing_rule
      (lib.concatMap
        (get_policy_routing_for_interface interfaces)
        (attrNames interfaces));

  rt_tables = toFile "rt_tables" ''
    # reserved values
    #
    255 local
    254 main
    253 default
    0 unspec
    #
    # local
    #
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n : vlan : "${n} ${vlan}")
      cfg.static.vlans
    )}
    '';

  # default route
  get_default_gateway = version_filter: interfaces:
    (head
    (sort
      (ruleset_a: ruleset_b: lessThan ruleset_a.priority ruleset_b.priority)
      (filter
        (ruleset: version_filter ruleset.network)
        (lib.concatMap
          (get_policy_routing_for_interface interfaces)
          (attrNames interfaces))))).gateway;

  # funny that the modulo function seems not to be defined anywhere
  mod = x : n : x - (div x n) * n;

  # convert value [0..15] into a single hex digit
  hexDigit = x : elemAt (lib.stringToCharacters "0123456789abcdef") x;

  # convert value [0..255] into two hex digits
  byteToHex = x : lib.concatStrings [
    (hexDigit (div x 16)) (hexDigit (mod x 16))
  ];

in
{

  options = {

    flyingcircus.network.policy_routing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable policy routing?";
      };
    };

  };

  config = rec {

    services.udev.extraRules = (lib.concatStrings
      (lib.mapAttrsToList (n : vlan : ''
        KERNEL=="eth*", ATTR{address}=="02:00:00:${
          byteToHex (lib.toInt n)}:??:??", NAME="eth${vlan}"
      '') cfg.static.vlans)
    );

    networking.domain = "gocept.net";

    networking.defaultGateway =
      if
        cfg.network.policy_routing.enable &&
        lib.hasAttrByPath ["parameters" "interfaces"] cfg.enc
      then get_default_gateway is_ip4 cfg.enc.parameters.interfaces
      else null;
    networking.defaultGateway6 =
      if
        cfg.network.policy_routing.enable &&
        lib.hasAttrByPath ["parameters" "interfaces"] cfg.enc
      then get_default_gateway is_ip6 cfg.enc.parameters.interfaces
      else null;

    # Only set nameserver if there is an enc set.
    networking.nameservers =
      if lib.hasAttrByPath ["parameters" "location"] cfg.enc
      then
        if hasAttr cfg.enc.parameters.location cfg.static.nameservers
        then cfg.static.nameservers.${cfg.enc.parameters.location}
        else []
      else [];
    networking.resolvconfOptions = "ndots:1 timeout:1 attempts:4 rotate";

    # If there is no enc data, we are probably not on FC platform.
    networking.search =
      if lib.hasAttrByPath ["parameters" "location"] cfg.enc
      then ["${cfg.enc.parameters.location}.gocept.net"
            "gocept.net"]
      else [];

    # data structure for all configured interfaces with their IP addresses:
    # { ethfe = { ip4 = [ "..." "..." ]; ip6 = [ "..." "..." ]; }; ... }
    networking.interfaces =
      if lib.hasAttrByPath ["parameters" "interfaces"] cfg.enc
      then get_network_configuration cfg.enc.parameters.interfaces
      else {};

    networking.localCommands =
      if
        cfg.network.policy_routing.enable &&
        lib.hasAttrByPath ["parameters" "interfaces"] cfg.enc
      then
        ''
          mkdir -p /etc/iproute2
          ln -sf ${rt_tables} /etc/iproute2/rt_tables

          ip -4 rule flush
          ip -4 rule add priority 32766 lookup main
          ip -4 rule add priority 32767 lookup default

          ip -6 rule flush
          ip -6 rule add priority 32766 lookup main
          ip -6 rule add priority 32767 lookup default

          ${toString (get_policy_routing cfg.enc.parameters.interfaces)}
        ''
        else "";

    # firewall configuration: generic options

    # allow srv access for machines in the same RG
    networking.firewall.allowPing = true;
    networking.firewall.rejectPackets = true;
    networking.firewall.extraCommands =
      let
        addrs = map (elem: elem.ip) cfg.enc_addresses.srv;
        rules = lib.optionalString
          (lib.hasAttr "ethsrv" networking.interfaces)
          lib.concatMapStrings (a: ''
            ${iptables a} -A nixos-fw -i ethsrv -s ${stripNetmask a
              } -j nixos-fw-accept
            '')
            addrs;
      in "# Accept traffic within the same resource group.\n${rules}";

    # DHCP settings
    networking.useDHCP = true;
    networking.dhcpcd.extraConfig = ''
      # IPv4ll gets in the way if we really do not want
      # an IPv4 address on some interfaces.
      noipv4ll
    '';
  };

}
