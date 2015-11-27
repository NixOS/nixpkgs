{ config, pkgs, lib, ... }:

let

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

  get_udev_interface_configuration = interfaces: interface_name:
    ''
    KERNEL=="eth*", ATTR{address}=="${(builtins.getAttr interface_name interfaces).mac}", NAME="eth${interface_name}"
    '';

  get_udev_configuration = interfaces:
    map
      (get_udev_interface_configuration interfaces)
      (builtins.attrNames interfaces);


  # Policy routing

  routing_priorities = {
    fe = 20;
    srv = 30;
  };

  get_routing_priority = interface_name:
    if builtins.hasAttr interface_name routing_priorities
    then builtins.getAttr interface_name routing_priorities
    else 100;

  get_policy_routing_for_network = interfaces: interface_name: network:
    {
      priority = get_routing_priority interface_name;
      network = network;
      interface = interface_name;
      gateway = builtins.getAttr network (builtins.getAttr interface_name interfaces).gateways;
    };

  get_policy_routing_for_interface = interfaces: interface_name:
    map
    (get_policy_routing_for_network interfaces interface_name)
    (builtins.attrNames
      (builtins.getAttr interface_name interfaces).gateways);


  render_policy_routing_rule = ruleset:
    ''
    ip rule add priority ${builtins.toString (ruleset.priority)} from ${ruleset.network} lookup ${ruleset.interface}
    ip route add default via ${ruleset.gateway} table ${ruleset.interface} || true
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

    200 sdsl
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
    dev = ["2a02:238:f030:1c2::53" "2a02:238:f030:1c3::53"];
    rzob = ["195.62.125.5" "2a02:248:101:62::32" "195.62.125.135" "2a02:248:101:63::53"];
    rzrl1 = ["2a02:2028:1007:8002::53" "2a02:2028:1007:8003::53"];
    whq = ["212.122.41.143" "2a02:238:f030:102::102a"  "212.122.41.169" "2a02:238:f030:103::53"];
  };

in
{

  config = {

    services.udev.extraRules =
      toString
      (get_udev_configuration config.enc.parameters.interfaces);


    networking.domain = "gocept.net";
    networking.hostName =
      if config.enc ? name
      then config.enc.name
      else "default";


  networking.defaultGateway =
    if config.enc ? parameters
    then get_default_gateway is_ip4 config.enc.parameters.interfaces
    else null;
  networking.defaultGateway6 =
    if config.enc ? parameters
    then get_default_gateway is_ip6 config.enc.parameters.interfaces
    else null;

  # Only set nameserver if there is an enc set.
  networking.nameservers =
  if config.enc ? parameters
  then
    if builtins.hasAttr config.enc.parameters.location ns_by_location
    then builtins.getAttr config.enc.parameters.location ns_by_location
    else []
  else [];

  # If there is no enc data, we are probably not on FC platform.
  networking.search =
    if config.enc ? parameters
    then ["${config.enc.parameters.location}.gocept.net"
          "gocept.net"]
    else [];

  networking.interfaces =
    if config.enc ? parameters
    then get_network_configuration config.enc.parameters.interfaces
    else {};

  networking.localCommands =
    if config.enc ? parameters
    then
      ''
        mkdir -p /etc/iproute2
        ln -sf ${rt_tables} /etc/iproute2/rt_tables

        ip rule flush

        ip rule add priority 32766 lookup main
        ip rule add priority 32767 lookup default

        ${builtins.toString
            (get_policy_routing config.enc.parameters.interfaces)}
      ''
      else "";
  };
}
