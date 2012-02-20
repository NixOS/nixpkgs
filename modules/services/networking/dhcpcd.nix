{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) dhcpcd;

  # Don't start dhclient on explicitly configured interfaces or on
  # interfaces that are part of a bridge.
  ignoredInterfaces =
    map (i: i.name) (filter (i: i ? ipAddress && i.ipAddress != "" ) config.networking.interfaces)
    ++ concatLists (attrValues (mapAttrs (n: v: v.interfaces) config.networking.bridges));

  # Config file adapted from the one that ships with dhcpcd.
  dhcpcdConf = pkgs.writeText "dhcpcd.conf"
    ''
      # Inform the DHCP server of our hostname for DDNS.
      hostname

      # A list of options to request from the DHCP server.
      option domain_name_servers, domain_name, domain_search, host_name
      option classless_static_routes, ntp_servers, interface_mtu

      # A ServerID is required by RFC2131.
      require dhcp_server_identifier

      # A hook script is provided to lookup the hostname if not set by
      # the DHCP server, but it should not be run by default.
      nohook lookup-hostname

      # Ignore peth* devices; on Xen, they're renamed physical
      # Ethernet cards used for bridging.  Likewise for vif* and tap*
      # (Xen) and virbr* and vnet* (libvirt).
      denyinterfaces ${toString ignoredInterfaces} peth* vif* tap* virbr* vnet*
    '';

in

{

  ###### interface

  options = {

    networking.useDHCP = mkOption {
      default = true;
      merge = mergeEnableOption;
      description = "
        Whether to use DHCP to obtain an IP adress and other
        configuration for all network interfaces that are not manually
        configured.
      ";
    };

  };


  ###### implementation

  config = mkIf config.networking.useDHCP {

    jobs.dhcpcd =
      { startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        path = [ dhcpcd pkgs.nettools pkgs.openresolv ];

        exec = "dhcpcd --config ${dhcpcdConf} --background --persistent";

        daemonType = "daemon";
      };

    environment.systemPackages = [ dhcpcd ];

    powerManagement.resumeCommands =
      ''
        ${config.system.build.upstart}/sbin/restart dhcpcd
      '';

  };

}
