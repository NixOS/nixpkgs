{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.immich-kiosk;
  format = pkgs.formats.yaml { };
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    ;
in
{
  meta.maintainers = with lib.maintainers; [ tlvince ];

  options.services.immich-kiosk = {
    enable = mkEnableOption "Immich Kiosk slideshow service";

    package = mkPackageOption pkgs "immich-kiosk" { };

    immichUrl = mkOption {
      type = types.str;
      example = "https://immich.example.com";
      description = ''
        URL of the Immich instance. Must include a port if one is needed.
      '';
    };

    immichApiKeyFile = mkOption {
      type = lib.types.pathWith {
        inStore = false;
        absolute = true;
      };
      example = "/run/secrets/immich-kiosk-api-key";
      description = ''
        Path to a file containing the Immich API key.
        The file should contain only the API key with no trailing newline.
      '';
    };

    kioskPasswordFile = mkOption {
      type = types.nullOr (
        lib.types.pathWith {
          inStore = false;
          absolute = true;
        }
      );
      default = null;
      example = "/run/secrets/immich-kiosk-password";
      description = ''
        Optional path to a file containing the kiosk UI password.
        See <https://docs.immichkiosk.app/configuration/additional-options/#password> for usage details.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = ''
        Port on which immich-kiosk will listen.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the immich-kiosk port.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
      };
      default = { };
      description = ''
        Configuration for immich-kiosk. See
        <https://github.com/damongolding/immich-kiosk#configuration>
        for available options.
      '';
      example = lib.literalExpression ''
        {
          albums = [
            "4fa933cf-051f-4621-9ac7-8d06776c261c"
            "6466548c-4995-4fb5-ab1f-f63cc9ff3e5f"
          ];
          duration = 30;
          layout = "splitview";
          disable_ui = true;
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.immich-kiosk = {
      description = "Immich Kiosk slideshow service";
      after = lib.mkIf config.services.immich.enable [ "immich-server.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        KIOSK_IMMICH_URL = cfg.immichUrl;
        KIOSK_PORT = toString cfg.port;
      }
      // lib.optionalAttrs (cfg.settings != { }) {
        KIOSK_CONFIG_FILE = toString (format.generate "config.yaml" { kiosk = cfg.settings; });
      };

      serviceConfig = {
        DynamicUser = true;
        ExecStart = lib.getExe cfg.package;
        Group = "immich-kiosk";
        LoadCredential = [
          "kiosk_immich_api_key:${cfg.immichApiKeyFile}"
        ]
        ++ lib.optional (cfg.kioskPasswordFile != null) "kiosk_password:${cfg.kioskPasswordFile}";
        Restart = "on-failure";
        RestartSec = 10;
        RuntimeDirectory = "immich-kiosk";
        SyslogIdentifier = "immich-kiosk";
        Type = "simple";
        User = "immich-kiosk";
        WorkingDirectory = "/run/immich-kiosk";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
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
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}
