{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    literalExpression
    ;

  cfg = config.services.isso;

  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "isso.conf" cfg.settings;
in
{

  options = {
    services.isso = {
      enable = mkEnableOption ''
        isso, a commenting server similar to Disqus.

        Note: The application's author suppose to run isso behind a reverse proxy.
        The embedded solution offered by NixOS is also only suitable for small installations
        below 20 requests per second
      '';

      settings = mkOption {
        description = ''
          Configuration for `isso`.

          See [Isso Server Configuration](https://posativ.org/isso/docs/configuration/server/)
          for supported values.
          You can set secrets using the secretFile option with environment variables following
          [the documentation](https://isso-comments.de/docs/reference/server-config/#environment-variables).
        '';

        type = types.submodule {
          freeformType = settingsFormat.type;
        };

        example = literalExpression ''
          {
            general = {
              host = "http://localhost";
            };
          }
        '';
      };

      secretFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          A file containing secrets as environment variables that will be used in the configuration.
          See [the documentation](https://isso-comments.de/docs/reference/server-config/#environment-variables) for details.
        '';
        example = "/run/secrets/isso.env";
      };
    };
  };

  config = mkIf cfg.enable {
    services.isso.settings.general.dbpath = lib.mkDefault "/var/lib/isso/comments.db";

    systemd.services.isso = {
      description = "isso, a commenting server similar to Disqus";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "isso";
        Group = "isso";

        EnvironmentFile = mkIf (cfg.secretFile != null) [ cfg.secretFile ];

        DynamicUser = true;

        StateDirectory = "isso";

        ExecStart = ''
          ${pkgs.isso}/bin/isso -c ${configFile}
        '';

        Restart = "on-failure";
        RestartSec = 1;

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
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
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };
}
