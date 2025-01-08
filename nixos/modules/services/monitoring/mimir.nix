{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    escapeShellArgs
    mkEnableOption
    mkPackageOption
    mkIf
    lib.mkOption
    types
    ;

  cfg = config.services.mimir;

  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.mimir = {
    enable = lib.mkEnableOption "mimir";

    configuration = lib.mkOption {
      type = (pkgs.formats.json { }).type;
      default = { };
      description = ''
        Specify the configuration for Mimir in Nix.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Specify a configuration file that Mimir should use.
      '';
    };

    package = lib.mkPackageOption pkgs "mimir" { };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--config.expand-env=true" ];
      description = ''
        Specify a list of additional command line flags,
        which get escaped and are then passed to Mimir.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # for mimirtool
    environment.systemPackages = [ cfg.package ];

    assertions = [
      {
        assertion = (
          (cfg.configuration == { } -> cfg.configFile != null)
          && (cfg.configFile != null -> cfg.configuration == { })
        );
        message = ''
          Please specify either
          'services.mimir.configuration' or
          'services.mimir.configFile'.
        '';
      }
    ];

    systemd.services.mimir = {
      description = "mimir Service Daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig =
        let
          conf =
            if cfg.configFile == null then
              settingsFormat.generate "config.yaml" cfg.configuration
            else
              cfg.configFile;
        in
        {
          ExecStart = "${cfg.package}/bin/mimir --config.file=${conf} ${lib.escapeShellArgs cfg.extraFlags}";
          DynamicUser = true;
          Restart = "always";
          ProtectSystem = "full";
          DevicePolicy = "closed";
          NoNewPrivileges = true;
          WorkingDirectory = "/var/lib/mimir";
          StateDirectory = "mimir";
        };
    };
  };
}
