{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.connman;
  configFile = pkgs.writeText "connman.conf" ''
    [General]
    NetworkInterfaceBlacklist=${lib.concatStringsSep "," cfg.networkInterfaceBlacklist}

    ${cfg.extraConfig}
  '';
  enableIwd = cfg.wifi.backend == "iwd";
in
{
  meta.maintainers = with lib.maintainers; [ AndersonTorres ];

  imports = [
    (lib.mkRenamedOptionModule [ "networking" "connman" ] [ "services" "connman" ])
  ];

  ###### interface

  options = {
    services.connman = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to use ConnMan for managing your network connections.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        description = "The connman package / build flavor";
        default = pkgs.connman;
        defaultText = lib.literalExpression "pkgs.connman";
        example = lib.literalExpression "pkgs.connmanFull";
      };

      enableVPN = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable ConnMan VPN service.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration lines appended to the generated connman configuration file.
        '';
      };

      networkInterfaceBlacklist = lib.mkOption {
        type = with lib.types; listOf str;
        default = [
          "vmnet"
          "vboxnet"
          "virbr"
          "ifb"
          "ve"
        ];
        description = ''
          Default blacklisted interfaces, this includes NixOS containers interfaces (ve).
        '';
      };

      wifi = {
        backend = lib.mkOption {
          type = lib.types.enum [
            "wpa_supplicant"
            "iwd"
          ];
          default = "wpa_supplicant";
          description = ''
            Specify the Wi-Fi backend used.
            Currently supported are {option}`wpa_supplicant` or {option}`iwd`.
          '';
        };
      };

      extraFlags = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        example = [ "--nodnsproxy" ];
        description = ''
          Extra flags to pass to connmand
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.networking.useDHCP;
        message = "You can not use services.connman with networking.useDHCP";
      }
      {
        # TODO: connman seemingly can be used along network manager and
        # connmanFull supports this - so this should be worked out somehow
        assertion = !config.networking.networkmanager.enable;
        message = "You can not use services.connman with networking.networkmanager";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    systemd.services.connman = {
      description = "Connection service";
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" ] ++ lib.optional enableIwd "iwd.service";
      requires = lib.optional enableIwd "iwd.service";
      serviceConfig = {
        Type = "dbus";
        BusName = "net.connman";
        Restart = "on-failure";
        ExecStart = toString (
          [
            "${cfg.package}/sbin/connmand"
            "--config=${configFile}"
            "--nodaemon"
          ]
          ++ lib.optional enableIwd "--wifi=iwd_agent"
          ++ cfg.extraFlags
        );
        StandardOutput = "null";
      };
    };

    systemd.services.connman-vpn = lib.mkIf cfg.enableVPN {
      description = "ConnMan VPN service";
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" ];
      before = [ "connman.service" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "net.connman.vpn";
        ExecStart = "${cfg.package}/sbin/connman-vpnd -n";
        StandardOutput = "null";
      };
    };

    systemd.services.net-connman-vpn = lib.mkIf cfg.enableVPN {
      description = "D-BUS Service";
      serviceConfig = {
        Name = "net.connman.vpn";
        before = [ "connman.service" ];
        ExecStart = "${cfg.package}/sbin/connman-vpnd -n";
        User = "root";
        SystemdService = "connman-vpn.service";
      };
    };

    networking = {
      useDHCP = false;
      wireless = {
        enable = lib.mkIf (!enableIwd) true;
        dbusControlled = true;
        iwd = lib.mkIf enableIwd {
          enable = true;
        };
      };
      networkmanager.enable = false;
    };
  };
}
