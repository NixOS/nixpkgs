{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.networking.networkmanager;

  stateDirs = "/var/lib/NetworkManager /var/lib/dhclient";

  configFile = pkgs.writeText "NetworkManager.conf" ''
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

  ipUpScript = pkgs.writeScript "01nixos-ip-up" ''
    #!/bin/sh
    if test "$2" = "up"; then
      ${config.system.build.systemd}/bin/systemctl start ip-up.target
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
      apply = list: [ pkgs.networkmanager pkgs.modemmanager ] ++ list;
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.etc = singleton {
      source = ipUpScript;
      target = "NetworkManager/dispatcher.d/01nixos-ip-up";
    };

    environment.systemPackages = cfg.packages;

    users.extraGroups = singleton {
      name = "networkmanager";
      gid = config.ids.gids.networkmanager;
    };

    jobs.networkmanager = {
      startOn = "started network-interfaces";
      stopOn = "stopping network-interfaces";

      path = [ pkgs.networkmanager ];

      preStart = ''
        mkdir -m 755 -p /etc/NetworkManager
        mkdir -m 700 -p /etc/NetworkManager/system-connections
        mkdir -m 755 -p ${stateDirs}
      '';

       exec = "NetworkManager --config=${configFile} --no-daemon";
    };

    networking.useDHCP = false;

    networking.wireless.enable = true;

    security.polkit.permissions = polkitConf;

    services.dbus.packages = cfg.packages;

    services.udev.packages = cfg.packages;
  };
}
