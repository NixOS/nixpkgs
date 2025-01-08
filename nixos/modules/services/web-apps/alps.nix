{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.alps;
in
{
  options.services.alps = {
    enable = lib.mkEnableOption "alps";

    port = lib.mkOption {
      type = lib.types.port;
      default = 1323;
      description = ''
        TCP port the service should listen on.
      '';
    };

    bindIP = lib.mkOption {
      default = "[::]";
      type = lib.types.str;
      description = ''
        The IP the service should listen on.
      '';
    };

    theme = lib.mkOption {
      type = lib.types.enum [
        "alps"
        "sourcehut"
      ];
      default = "sourcehut";
      description = ''
        The frontend's theme to use.
      '';
    };

    imaps = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 993;
        description = ''
          The IMAPS server port.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "[::1]";
        example = "mail.example.org";
        description = ''
          The IMAPS server address.
        '';
      };
    };

    smtps = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 465;
        description = ''
          The SMTPS server port.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = cfg.imaps.host;
        defaultText = "services.alps.imaps.host";
        example = "mail.example.org";
        description = ''
          The SMTPS server address.
        '';
      };
    };

    package = lib.mkOption {
      internal = true;
      type = lib.types.package;
      default = pkgs.alps;
    };

    args = lib.mkOption {
      internal = true;
      type = lib.types.listOf lib.types.str;
      default = [
        "-addr"
        "${cfg.bindIP}:${toString cfg.port}"
        "-theme"
        "${cfg.theme}"
        "imaps://${cfg.imaps.host}:${toString cfg.imaps.port}"
        "smtps://${cfg.smtps.host}:${toString cfg.smtps.port}"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.alps = {
      description = "alps is a simple and extensible webmail.";
      documentation = [ "https://git.sr.ht/~migadu/alps" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/alps ${lib.escapeShellArgs cfg.args}";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindAllow = cfg.port;
        SocketBindDeny = "any";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @obsolete"
        ];
      };
    };
  };
}
