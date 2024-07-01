{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.pixivfe;
in
{
  options.services.pixivfe = {
    enable = lib.mkEnableOption "PixivFE, a privacy respecting frontend for Pixiv";

    package = lib.mkPackageOption pkgs "pixivfe" { };

    openFirewall = lib.mkEnableOption "open ports in the firewall needed for the daemon to function";

    settings = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.anything);
      default = null;
      example = lib.literalExpression ''
        {
          PIXIVFE_PORT = "8282";
          PIXIVFE_TOKEN = "123456_AaBbccDDeeFFggHHIiJjkkllmMnnooPP";
        };
      '';
      description = ''
        Additional configuration for PixivFE, see
        <https://pixivfe.pages.dev/environment-variables/> for supported values.
        For secrets use `EnvironmentFile` option instead.
      '';
    };

    EnvironmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = lib.literalExpression ''
        /run/secrets/environment
      '';
      description = ''
        File containing environment variables to be passed to the PixivFE service.

        See `systemd.exec(5)` for more information.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = if cfg.openFirewall then (cfg.settings ? PIXIVFE_PORT) else true;
        message = ''
          PIXIVFE_PORT must be specified for NixOS to open a port.

          See https://pixivfe.pages.dev/environment-variables/ for more information.
        '';
      }
      {
        assertion =
          if (cfg.EnvironmentFile == null) then
            (cfg.settings ? PIXIVFE_UNIXSOCKET) || (cfg.settings ? PIXIVFE_PORT)
          else
            true;
        message = ''
          PIXIVFE_PORT or PIXIVFE_UNIXSOCKET must be set for PixivFE to run.

          See https://pixivfe.pages.dev/environment-variables/ for more information.
        '';
      }
      {
        assertion = if (cfg.EnvironmentFile == null) then cfg.settings ? PIXIVFE_TOKEN else true;
        message = ''
          PIXIVFE_TOKEN must be set for PixivFE to run.

          See https://pixivfe.pages.dev/environment-variables/ for more information.
        '';
      }
    ];

    systemd.services."pixivfe" = {
      description = "PixivFE, a privacy respecting frontend for Pixiv.";
      documentation = [ "https://pixivfe.pages.dev/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      environment = lib.mkIf (cfg.settings != null) (
        lib.mapAttrs (_: v: if lib.isBool v then lib.boolToString v else toString v) cfg.settings
      );
      serviceConfig = {
        inherit (cfg) EnvironmentFile;
        ExecStart = lib.getExe cfg.package;
        DynamicUser = true;

        ### Hardening
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ]; # For ports <= 1024
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
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
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.PIXIVFE_PORT ];
    };
  };

  meta.maintainers = with lib.maintainers; [ Guanran928 ];
}
