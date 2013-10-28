{ config, pkgs, ... }:

with pkgs.lib;
with pkgs;

let
  cfg = config.networking.networkmanager;

  stateDirs = "/var/lib/NetworkManager /var/lib/dhclient";

  configFile = writeText "NetworkManager.conf" ''
    [main]
    plugins=keyfile

    [keyfile]
    ${optionalString (config.networking.hostName != "") ''
      hostname=${config.networking.hostName}
    ''}

    [logging]
    level=WARN
  '';

  polkitConf = ''
    [network-manager]
    Identity=unix-group:networkmanager
    Action=org.freedesktop.NetworkManager.*
    ResultAny=yes
    ResultInactive=no
    ResultActive=yes

    [modem-manager]
    Identity=unix-group:networkmanager
    Action=org.freedesktop.ModemManager.*
    ResultAny=yes
    ResultInactive=no
    ResultActive=yes
  '';

  ipUpScript = writeScript "01nixos-ip-up" ''
    #!/bin/sh
    if test "$2" = "up"; then
      ${config.systemd.package}/bin/systemctl start ip-up.target
    fi
  '';

  overrideNameserversScript = writeScript "02overridedns" ''
    #!/bin/sh
    ${optionalString cfg.overrideNameservers "${gnused}/bin/sed -i '/nameserver /d' /etc/resolv.conf"}
    ${concatStrings (map (s: ''
      ${optionalString cfg.appendNameservers
        "${gnused}/bin/sed -i '/nameserver ${s}/d' /etc/resolv.conf"
      }
      echo 'nameserver ${s}' >> /etc/resolv.conf
    '') config.networking.nameservers)}
  '';

in {

  ###### interface

  options = {

    networking.networkmanager = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use NetworkManager to obtain an IP address and other
          configuration for all network interfaces that are not manually
          configured. If enabled, a group <literal>networkmanager</literal>
          will be created. Add all users that should have permission
          to change network settings to this group.
        '';
      };
  
      packages = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          Extra packages that provide NetworkManager plugins.
        '';
        apply = list: [ networkmanager modemmanager wpa_supplicant ] ++ list;
      };

      overrideNameservers = mkOption {
        default = false;
        description = ''
          If enabled, any nameservers received by DHCP or configured in
          NetworkManager will be replaced by the nameservers configured
          in the <literal>networking.nameservers</literal> option. This
          option overrides the <literal>appendNameservers</literal> option
          if both are enabled.
        '';
      };

      appendNameservers = mkOption {
        default = false;
        description = ''
          If enabled, the name servers configured in the
          <literal>networking.nameservers</literal> option will be appended
          to the ones configured in NetworkManager or received by DHCP.
        '';
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [{
      assertion = config.networking.wireless.enable == false;
      message = "You can not use networking.networkmanager with services.networking.wireless";
    }];

    environment.etc = [
      { source = ipUpScript;
        target = "NetworkManager/dispatcher.d/01nixos-ip-up";
      }
      { source = configFile;
        target = "NetworkManager/NetworkManager.conf";
      }
      { source = "${networkmanager_openvpn}/etc/NetworkManager/VPN/nm-openvpn-service.name";
        target = "NetworkManager/VPN/nm-openvpn-service.name";
      }
      { source = "${networkmanager_vpnc}/etc/NetworkManager/VPN/nm-vpnc-service.name";
        target = "NetworkManager/VPN/nm-vpnc-service.name";
      }
      { source = "${networkmanager_openconnect}/etc/NetworkManager/VPN/nm-openconnect-service.name";
        target = "NetworkManager/VPN/nm-openconnect-service.name";
      }
    ] ++ pkgs.lib.optional (cfg.overrideNameservers || cfg.appendNameservers)
           { source = overrideNameserversScript;
             target = "NetworkManager/dispatcher.d/02overridedns";
           };

    environment.systemPackages = cfg.packages ++ [
        networkmanager_openvpn
        networkmanager_vpnc
        networkmanager_openconnect
        ];

    users.extraGroups = singleton {
      name = "networkmanager";
      gid = config.ids.gids.networkmanager;
    };

    systemd.packages = cfg.packages;

    # Create an initialisation service that both starts
    # NetworkManager when network.target is reached,
    # and sets up necessary directories for NM.
    systemd.services."networkmanager-init" = {
      description = "NetworkManager initialisation";
      wantedBy = [ "network.target" ];
      partOf = [ "NetworkManager.service" ];
      wants = [ "NetworkManager.service" ];
      before = [ "NetworkManager.service" ];
      script = ''
        mkdir -m 700 -p /etc/NetworkManager/system-connections
        mkdir -m 755 -p ${stateDirs}
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    # Turn off NixOS' network management
    networking = {
      useDHCP = false;
      wireless.enable = false;
    };

    powerManagement.resumeCommands = ''
      systemctl restart NetworkManager
    '';

    security.polkit.permissions = polkitConf;

    # openvpn plugin has only dbus interface
    services.dbus.packages = cfg.packages ++ [
        networkmanager_openvpn
        networkmanager_vpnc
        networkmanager_openconnect
        ];

    services.udev.packages = cfg.packages;
  };
}
