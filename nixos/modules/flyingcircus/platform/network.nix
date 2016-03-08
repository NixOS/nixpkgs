{ config, pkgs, lib, ... }:

let

  cfg = config.flyingcircus;

  get_prefix_length = network:
    lib.toInt (builtins.elemAt (lib.splitString "/" network) 1);

  is_ip4 = address_or_network:
    builtins.length (lib.splitString "." address_or_network) > 1;

  is_ip6 = address_or_network:
    builtins.length (lib.splitString ":" address_or_network) > 1;

  _ip_interface_configuration = networks: network:
      map (
        ip_address: {
          address = ip_address;
          prefixLength = get_prefix_length network;
        })
       (builtins.getAttr network networks);

  get_ip_configuration = version_filter: networks:
    lib.concatMap
      (_ip_interface_configuration networks)
      (builtins.filter version_filter (builtins.attrNames networks));


  get_interface_ips = networks:
    { ip4 = get_ip_configuration is_ip4 networks;
      ip6 = get_ip_configuration is_ip6 networks;
    };

  get_interface_configuration = interfaces: interface_name:
    { name = "eth${interface_name}";
      value = get_interface_ips (builtins.getAttr interface_name interfaces).networks;
    };

  get_network_configuration = interfaces:
    builtins.listToAttrs
      (map
       (get_interface_configuration interfaces)
       (builtins.attrNames interfaces));


  # Configration for UDEV
  get_udev_configuration = interfaces:
    map
      (interface_name: ''
       KERNEL=="eth*", ATTR{address}=="${lib.toLower (builtins.getAttr
         interface_name interfaces).mac}", NAME="eth${interface_name}"
       '')
      (builtins.attrNames interfaces);


  # Policy routing

  routing_priorities = {
    fe = 20;
    srv = 30;
  };

  get_policy_routing_for_interface = interfaces: interface_name:
    map (network: {
           priority =
            if builtins.hasAttr interface_name routing_priorities
            then builtins.getAttr interface_name routing_priorities
            else 100;
           network = network;
           interface = interface_name;
           gateway = builtins.getAttr network (builtins.getAttr interface_name interfaces).gateways;
           addresses = builtins.getAttr network (builtins.getAttr interface_name interfaces).networks;
           family = if (is_ip4 network) then "4" else "6";
         })
        (builtins.attrNames
          (builtins.getAttr interface_name interfaces).gateways);


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
          (address: "ip -${ruleset.family} rule add priority ${builtins.toString (ruleset.priority)} from ${address} lookup ${ruleset.interface}")
          ruleset.addresses;
      render_gateway_rule =
        if (builtins.length ruleset.addresses) > 0 then
          "ip -${ruleset.family} route add default via ${ruleset.gateway} table ${ruleset.interface} || true"
        else
          "";
    in
    ''
    ${render_address_rules}
    ip -${ruleset.family} rule add priority ${builtins.toString (ruleset.priority)} from all to ${ruleset.network} lookup ${ruleset.interface}
    ${render_gateway_rule}
    '';

  get_policy_routing = interfaces:
    map
      render_policy_routing_rule
      (lib.concatMap
        (get_policy_routing_for_interface interfaces)
        (builtins.attrNames interfaces));

  rt_tables = builtins.toFile "rt_tables" ''
    # reserved values
    #
    255 local
    254 main
    253 default
    0 unspec
    #
    # local
    #
    1 mgm
    2 fe
    3 srv
    4 sto
    5 ws
    6 tr
    7 guest
    8 stb
    '';

  # default route.

  get_default_gateway = version_filter: interfaces:
    (builtins.head
    (builtins.sort
      (ruleset_a: ruleset_b: builtins.lessThan ruleset_a.priority ruleset_b.priority)
      (builtins.filter
        (ruleset: version_filter ruleset.network)
        (lib.concatMap
          (get_policy_routing_for_interface interfaces)
          (builtins.attrNames interfaces))))).gateway;


  ns_by_location = {
    # ns.$location.gocept.net, ns2.$location.gocept.net
    # We are currently not using IPv6 resolvers as we have seen obscure bugs
    # when enabling them, like weird search path confusion that results in
    # arbitrary negative responses, combined with the rotate flag.
    #
    # This seems to be https://sourceware.org/bugzilla/show_bug.cgi?id=13028
    # which is fixed in glibc 2.22 which is included in NixOS 16.03.
    dev = ["172.30.3.10" "172.20.2.38"];
    rzob = ["195.62.125.5" "195.62.125.135"];
    rzrl1 = ["172.24.32.3" "172.24.48.4"];
    whq = ["212.122.41.143" "212.122.41.169"];
  };

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

  config = {

    services.udev.extraRules =
      if lib.hasAttrByPath ["parameters" "interfaces"] cfg.enc
      then
        toString
        (get_udev_configuration cfg.enc.parameters.interfaces)
      else "";

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
        if builtins.hasAttr cfg.enc.parameters.location ns_by_location
        then builtins.getAttr cfg.enc.parameters.location ns_by_location
        else []
      else [];
    networking.resolvconfOptions = "ndots:1 timeout:1 attempts:4 rotate";

    # If there is no enc data, we are probably not on FC platform.
    networking.search =
      if lib.hasAttrByPath ["parameters" "location"] cfg.enc
      then ["${cfg.enc.parameters.location}.gocept.net"
            "gocept.net"]
      else [];

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

          ${builtins.toString
              (get_policy_routing cfg.enc.parameters.interfaces)}
        ''
        else "";

    networking.firewall.allowPing = true;
    networking.firewall.rejectPackets = true;
    networking.useDHCP = true;
    networking.dhcpcd.extraConfig = ''
      # IPv4ll gets in the way if we really do not want
      # an IPv4 address on some interfaces.
      noipv4ll
    '';

  };

}
