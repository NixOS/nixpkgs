{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.create_ap;

  valueToText =
    let
      conversions = {
        string = id;
        int = toString;
        bool = value: if value then "1" else "0";
      };
    in value: conversions.${builtins.typeOf value} value;

  configFile = pkgs.writeText "create_ap.conf"
    (concatStrings (mapAttrsToList (name: value:
      "${name}=${valueToText value}\n"
    ) (filterAttrs (_: value: value != null) cfg.settings)));

  wifiIface = cfg.settings.WIFI_IFACE;
  inetIface = cfg.settings.INTERNET_IFACE;

in {

  options.services.create_ap = with types; {
    enable = mkEnableOption "Enable Create Access Point Service";

    settings = mkOption {
      type = attrsOf (nullOr (oneOf [ str int bool ]));
      description = ''
        create_ap configuration, see <link xlink:href="https://github.com/oblique/create_ap/blob/master/create_ap.conf"/>
        for information on supported values.
      '';
      example = literalExample ''
        {
          HIDDEN = true;
          FREQ_BAND = 5;
          DHCP_DNS = "1.1.1.1";
          COUNTRY = "US";
        }
      '';
    };

    wifiInterface = mkOption {
      description = ''
        Wi-Fi interface to use (Use <command>ip link show</command> to list available).
      '';
      type = str;
      example = "wlan0";
    };

    internetInterface = mkOption {
      description = ''
        Interface to use for internet connection (Use <command>ip link show</command> to list available).
      '';
      type = str;
      example = "enp0";
    };

    ssid = mkOption {
      description = "SSID of the access point.";
      type = str;
      example = "MyAccessPoint";
    };

    passphrase = mkOption {
      description = "Passphrase to use for access point.";
      type = str;
      example = "12345678";
    };

    gateway = mkOption {
      description = "IPv4 Gateway for the Access Point.";
      type = str;
      default = "192.168.12.1";
      example = "10.0.0.1";
    };

    channel = mkOption {
      type = either str int;
      example = 1;
      default = "default";
      description = "WLAN Channel number.";
    };
  };

  config = mkIf cfg.enable {

    services.create_ap.settings = {
      DAEMONIZE = false;
      CHANNEL = mkDefault cfg.channel;
      GATEWAY = mkDefault cfg.gateway;
      WIFI_IFACE = mkDefault cfg.wifiInterface;
      INTERNET_IFACE = mkDefault cfg.internetInterface;
      SSID = mkDefault cfg.ssid;
      PASSPHRASE = mkDefault cfg.passphrase;
    };

    environment.systemPackages =  [ pkgs.create_ap ];

    systemd.services.create_ap = {
      description = "Create AP Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target"
                "sys-subsystem-net-devices-${wifiIface}.device"
                "sys-subsystem-net-devices-${inetIface}.device" ];
      bindsTo = [ "sys-subsystem-net-devices-${wifiIface}.device"
                  "sys-subsystem-net-devices-${inetIface}.device" ];
      serviceConfig =
        let capabilities = [
          "CAP_CHOWN"
          "CAP_DAC_OVERRIDE"
          "CAP_DAC_READ_SEARCH"
          "CAP_KILL"
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
          "CAP_NET_BIND_SERVICE"
        ]; in {
          KillSignal = "SIGINT";
          Restart = "on-failure";
          RestartSec = 5;
          DynamicUser = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          # create_ap parses and updates NetworkManager.conf
          ReadWritePaths = "-/etc/NetworkManager/";
          AmbientCapabilities = capabilities;
          CapabilityBoundingSet = capabilities;
          ExecStart = "${pkgs.create_ap}/bin/create_ap --config ${configFile}";
        };
    };
  };
}
