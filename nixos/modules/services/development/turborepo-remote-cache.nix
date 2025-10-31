{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.turborepo-remote-cache;

  inherit (lib)
    literalExpression
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;
  inherit (lib)
    boolToString
    isBool
    mapAttrs
    mkIf
    ;
in
{
  options.services.turborepo-remote-cache = {
    enable = mkEnableOption "Turborepo Remote Cache" // {
      description = ''
        Enables the daemon for `turborepo-remote-cache`,
        an open source implementation of the Turborepo custom remote cache server.
      '';
    };

    package = mkPackageOption pkgs "turborepo-remote-cache" { };

    environment = mkOption {
      type = types.attrsOf (
        types.nullOr (
          types.oneOf [
            types.bool
            types.int
            types.str
          ]
        )
      );
      default = { };
      description = ''
        Environment variables to set.

        Turborepo-remote-cache is configured through the use of environment variables.
        The available configuration options can be found in the [documentation][envvars].

        [envvars]: https://ducktors.github.io/turborepo-remote-cache/environment-variables.html

        Note that all environment variables set through this configuration
        parameter will be readable by anyone with access to the host
        machine. Therefore, sensitive information like {env}`TURBO_TOKEN`
        should never be set using this configuration option, but should instead use
        [](#opt-services.turborepo-remote-cache.environmentFile).
        See the documentation for that option for more information.

        Any environment variables specified in the
        [](#opt-services.turborepo-remote-cache.environmentFile)
        will supersede environment variables specified in this option.
      '';

      example = literalExpression ''
        {
          NODE_ENV = "production";
          PORT = 8080;
        }
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Additional environment file as defined in {manpage}`systemd.exec(5)`.

        Secrets like {env}`TURBO_TOKEN` may be passed to the
        service without making them readable to everyone with access to
        systemctl by using this configuration parameter.

        Note that this file needs to be available on the host on which
        `turborepo-remote-cache` is running.

        See the [documentation][envvars]
        and the [](#opt-services.turborepo-remote-cache.environment) configuration parameter
        for further options.

        [envvars]: https://ducktors.github.io/turborepo-remote-cache/environment-variables.html
      '';
      example = "/run/secrets/turborepo-remote-cache.env";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports in the firewall for turborepo-remote-cache daemon.
      '';
    };
  };

  config = {
    systemd.services.turborepo-remote-cache = {
      serviceConfig = {
        Restart = "always";
        EnvironmentFile = cfg.environmentFile;
        ExecStart = "${cfg.package}/bin/turborepo-remote-cache";

        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
      };
      environment = mapAttrs (
        name: value: if isBool value then boolToString value else toString value
      ) cfg.environment;
      wantedBy = [ "default.target" ];
    };

    networking.firewall.allowedTCPPorts =
      let
        # 3000 is the default port as specified in
        # https://ducktors.github.io/turborepo-remote-cache/environment-variables.html
        port = cfg.environment.PORT or 3000;
      in
      mkIf cfg.openFirewall [ port ];
  };
}
