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

in {

  ###### interface

  options = {

    networking.networkmanager.enable = mkOption {
      default = false;
      merge = mergeEnableOption;
      description = ''
        Whether to use NetworkManager to obtain an IP adress and other
        configuration for all network interfaces that are not manually
        configured. If enabled, a group <literal>networkmanager</literal>
        will be created. Add all users that should have permission
        to change network settings to this group.
      '';
    };

    networking.networkmanager.packages = mkOption {
      default = [ ];
      description = ''
        Extra packages that provide NetworkManager plugins.
      '';
      merge = mergeListOption;
      apply = list: [ networkmanager modemmanager wpa_supplicant ] ++ list;
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.etc = [
      { source = ipUpScript;
        target = "NetworkManager/dispatcher.d/01nixos-ip-up";
      }
      { source = configFile;
        target = "NetworkManager/NetworkManager.conf";
      }
    ];

    environment.systemPackages = cfg.packages;

    users.extraGroups = singleton {
      name = "networkmanager";
      gid = config.ids.gids.networkmanager;
    };

    systemd.packages = cfg.packages;

    # Create an initialisation service that both starts
    # NetworkManager when network.target is reached,
    # and sets up necessary directories for NM.
    systemd.services."NetworkManager-init" = {
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

    security.polkit.permissions = polkitConf;

    services.dbus.packages = cfg.packages;

    services.udev.packages = cfg.packages;
  };
}
