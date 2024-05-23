{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.pixivfe;
  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.pixivfe = {
    enable = lib.mkEnableOption "PixivFE, a privacy respecting frontend for Pixiv";

    package = lib.mkPackageOption pkgs "pixivfe" { };

    openFirewall = lib.mkEnableOption "open ports in the firewall needed for the daemon to function";

    settings = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule {
          freeformType = settingsFormat.type;
        }
      );
      default = { };
      example = lib.literalExpression ''
        {
          port = "8282";
          token = "123456_AaBbccDDeeFFggHHIiJjkkllmMnnooPP";
        };
      '';
      description = ''
        Additional configuration for PixivFE, see
        <https://pixivfe-docs.pages.dev/hosting/configuration-options/> for supported values.
        For secrets use `EnvironmentFile` option instead.
      '';
    };

    EnvironmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = lib.literalExpression "/run/secrets/environment";
      description = ''
        File containing environment variables to be passed to the PixivFE service.

        See EnvironmentFile in {manpage}`systemd.exec(5)` for more information.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.openFirewall -> (cfg.settings ? port);
        message = ''
          `servires.pixivfe.settings.port` must be specified for NixOS to open a port.

          See https://pixivfe-docs.pages.dev/hosting/configuration-options/ for more information.
        '';
      }
      {
        assertion = (cfg.EnvironmentFile == null) -> (cfg.settings ? port) || (cfg.settings ? unixSocket);
        message = ''
          `services.pixivfe.settings.port` or `services.pixivfe.settings.unixSocket` must be set for PixivFE to run.

          See https://pixivfe-docs.pages.dev/hosting/configuration-options/ for more information.
        '';
      }
      {
        assertion = (cfg.EnvironmentFile == null) -> (cfg.settings ? token);
        message = ''
          `services.pixivfe.settings.token` or the setting's corresponding environment variable must be set for PixivFE to run.

          See https://pixivfe-docs.pages.dev/hosting/configuration-options/ for more information.
        '';
      }
    ];

    systemd.services.pixivfe = {
      description = "PixivFE, a privacy respecting frontend for Pixiv.";
      documentation = [ "https://pixivfe-docs.pages.dev/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig =
        {
          inherit (cfg) EnvironmentFile;
          ExecStart = lib.concatStringsSep " " [
            (lib.getExe cfg.package)
            "-config"
            (settingsFormat.generate "config.yaml" cfg.settings)
          ];
          DynamicUser = true;

          ### Hardening
          NoNewPrivileges = true;
          PrivateMounts = true;
          PrivateTmp = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
          UMask = "0077";
        }
        // lib.optionalAttrs
          (cfg.EnvironmentFile != null || (cfg.settings ? port && cfg.settings.port <= 1024))
          {
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ Guanran928 ];
}
