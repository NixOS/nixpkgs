{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.alps;
in {
  options.services.alps = {
    enable = mkEnableOption (lib.mdDoc "alps");

    port = mkOption {
      type = types.port;
      default = 1323;
      description = lib.mdDoc ''
        TCP port the service should listen on.
      '';
    };

    bindIP = mkOption {
      default = "[::]";
      type = types.str;
      description = lib.mdDoc ''
        The IP the service should listen on.
      '';
    };

    theme = mkOption {
      type = types.enum [ "alps" "sourcehut" ];
      default = "sourcehut";
      description = lib.mdDoc ''
        The frontend's theme to use.
      '';
    };

    imaps = {
      port = mkOption {
        type = types.port;
        default = 993;
        description = lib.mdDoc ''
          The IMAPS server port.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "[::1]";
        example = "mail.example.org";
        description = lib.mdDoc ''
          The IMAPS server address.
        '';
      };
    };

    smtps = {
      port = mkOption {
        type = types.port;
        default = 465;
        description = lib.mdDoc ''
          The SMTPS server port.
        '';
      };

      host = mkOption {
        type = types.str;
        default = cfg.imaps.host;
        defaultText = "services.alps.imaps.host";
        example = "mail.example.org";
        description = lib.mdDoc ''
          The SMTPS server address.
        '';
      };
    };

    package = mkOption {
      internal = true;
      type = types.package;
      default = pkgs.alps;
    };

    args = mkOption {
      internal = true;
      type = types.listOf types.str;
      default = [
        "-addr" "${cfg.bindIP}:${toString cfg.port}"
        "-theme" "${cfg.theme}"
        "imaps://${cfg.imaps.host}:${toString cfg.imaps.port}"
        "smtps://${cfg.smtps.host}:${toString cfg.smtps.port}"
      ];
    };
  };

  config = mkIf cfg.enable {
    systemd.services.alps = {
      description = "alps is a simple and extensible webmail.";
      documentation = [ "https://git.sr.ht/~migadu/alps" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/alps ${escapeShellArgs cfg.args}";
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindAllow = cfg.port;
        SocketBindDeny = "any";
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged @obsolete" ];
      };
    };
  };
}
