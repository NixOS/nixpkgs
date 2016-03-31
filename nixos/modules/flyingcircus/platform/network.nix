{ config, lib, ... }:

with builtins;

let
  cfg = config.flyingcircus;

  fclib = import ../lib;

  # choose the correct iptables version for addr
  iptables = addr: if fclib.isIp4 addr then "iptables" else "ip6tables";

  _ip_interface_configuration = networks: network:
      map (
        ip_address: {
          address = ip_address;
          prefixLength = fclib.prefixLength network;
        })
       (getAttr network networks);

  get_ip_configuration = version_filter: networks:
    lib.concatMap
      (_ip_interface_configuration networks)
      (filter version_filter (attrNames networks));


  get_interface_ips = networks:
    { ip4 = get_ip_configuration fclib.isIp4 networks;
      ip6 = get_ip_configuration fclib.isIp6 networks;
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
    map (network:
    let
      addresses = getAttr network (getAttr interface_name interfaces).networks;
    in
    {
       priority =
        if builtins.length addresses == 0
        then 1000
        else lib.attrByPath [ interface_name ] 100 routing_priorities;
       network = network;
       interface = interface_name;
       gateway = getAttr network (getAttr interface_name interfaces).gateways;
       addresses = addresses;
       family = if (fclib.isIp4 network) then "4" else "6";
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
  policy_routing_rules = ruleset:
    let
      address_rules =
        lib.concatMapStrings
          (address: ''
            ip -${ruleset.family} rule add priority ${toString (ruleset.priority)} from ${address} lookup ${ruleset.interface}
          '')
          ruleset.addresses;
      gateway_rule = lib.optionalString
        ((length ruleset.addresses) > 0)
        ''
          ip -${ruleset.family} route add default via ${ruleset.gateway} table ${ruleset.interface} || true
        '';
    in
    ''
      # policy routing rules for ${ruleset.interface}/IPv${ruleset.family}
      ${address_rules}
      ip -${ruleset.family} rule add priority ${toString (ruleset.priority)} from all to ${ruleset.network} lookup ${ruleset.interface}
      ${gateway_rule}
    '';

  get_policy_routing = interfaces:
    map
      policy_routing_rules
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
          fclib.byteToHex (lib.toInt n)}:??:??", NAME="eth${vlan}"
      '') cfg.static.vlans)
    );

    networking.domain = "gocept.net";

    networking.defaultGateway =
      if
        cfg.network.policy_routing.enable &&
        lib.hasAttrByPath ["parameters" "interfaces"] cfg.enc
      then get_default_gateway fclib.isIp4 cfg.enc.parameters.interfaces
      else null;
    networking.defaultGateway6 =
      if
        cfg.network.policy_routing.enable &&
        lib.hasAttrByPath ["parameters" "interfaces"] cfg.enc
      then get_default_gateway fclib.isIp6 cfg.enc.parameters.interfaces
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
    # { ethfe = { ... }; ethsrv = { }; ... }
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

          ${lib.concatStrings (get_policy_routing cfg.enc.parameters.interfaces)}
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
          (lib.concatMapStrings (a: ''
            ${iptables a} -A nixos-fw -i ethsrv -s ${fclib.stripNetmask a
              } -j nixos-fw-accept
            '')
            addrs);
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
