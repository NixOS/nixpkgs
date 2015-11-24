{ config, pkgs, lib, ... }:

let

  # string -> int; well, I call this a hack.
  toInt = str:
    builtins.fromJSON str;

  get_prefix_length = network:
    toInt (builtins.elemAt (lib.splitString "/" network) 1);

  is_ip4 = address_or_network:
    builtins.length (lib.splitString "." address_or_network) > 1;

  is_ip6 = address_or_network:
    builtins.length (lib.splitString ":" address_or_network) > 1;


  _ip_configuration = network: ip_address:
    {
      address = ip_address;
      prefixLength = get_prefix_length network;
    };

  _ip_interface_configuration = networks: network:
      map (_ip_configuration network) (builtins.getAttr network networks);

  get_ip_configuration = version_filter: networks:
    builtins.concatLists
    (map
      (_ip_interface_configuration networks)
      (builtins.filter version_filter (builtins.attrNames networks)));


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

  #
  #  networking.localCommands = ''
  #        ip rule flush
  #
  #    ip rule add priority 32766 lookup main
  #    ip rule add priority 32767 lookup default
  #
  #    ip rule add priority 1 from 172.20.1.0/24 lookup 1
  #        ip route add default via 172.20.1.1 table 1 || true
  #
  #    ip rule add priority 2 from 172.20.2.0/24 lookup 2
  #        ip route add default via 172.20.2.1 table 2 || true
  #
  #    ip rule add priority 3 from 172.20.3.0/24 lookup 3
  #        ip route add default via 172.20.3.1 table 3 || true
  #
  #    ip rule add priority 4 from 172.20.4.0/24 lookup 4
  #        ip route add default via 172.20.4.1 table 4 || true
  #  '';
  };
}
