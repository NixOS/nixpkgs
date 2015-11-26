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
    ''
    ip rule add priority ${builtins.toString (get_routing_priority interface_name)} from ${network} lookup ${interface_name}
    ip route add default via ${builtins.getAttr network (builtins.getAttr interface_name interfaces).gateways} table ${interface_name} || true
    '';

  get_policy_routing_for_interface = interfaces: interface_name:
    map
    (get_policy_routing_for_network interfaces interface_name)
    (builtins.attrNames
      (builtins.getAttr interface_name interfaces).gateways);

  get_policy_routing = interfaces:
    builtins.concatLists
      (map
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


  #  networking.defaultGateway = "172.20.1.1";
  #  networking.defaultGateway6 = "2a02:238:f030:1c1::1";

  #  networking.nameservers = [
  #    "172.20.2.38"
  #    "172.30.3.10"
  #  ];
  #  networking.search = [
  #    "dev.gocept.net"
  #    "gocept.net"
  #  ];

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
