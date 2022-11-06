{ config, lib, pkgs, ... }:

let
  inherit (lib) escapeShellArgs mkEnableOption mkIf mkOption types;

  cfg = config.services.mimir;

  settingsFormat = pkgs.formats.yaml {};
in {
  options.services.mimir = {
    enable = mkEnableOption (lib.mdDoc "mimir");

    configuration = mkOption {
      type = (pkgs.formats.json {}).type;
      default = {};
      description = lib.mdDoc ''
        Specify the configuration for Mimir in Nix.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Specify a configuration file that Mimir should use.
      '';
    };

    package = mkOption {
      default = pkgs.mimir;
      defaultText = lib.literalExpression "pkgs.mimir";
      type = types.package;
      description = lib.mdDoc ''Mimir package to use.'';
    };
  };

  config = mkIf cfg.enable {
    # for mimirtool
    environment.systemPackages = [ pkgs.mimir ];

    assertions = [{
      assertion = (
        (cfg.configuration == {} -> cfg.configFile != null) &&
        (cfg.configFile != null -> cfg.configuration == {})
      );
      message  = ''
        Please specify either
        'services.mimir.configuration' or
        'services.mimir.configFile'.
      '';
    }];

    systemd.services.mimir = {
      description = "mimir Service Daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        conf = if cfg.configFile == null
               then settingsFormat.generate "config.yaml" cfg.configuration
               else cfg.configFile;
      in
      {
        ExecStart = "${cfg.package}/bin/mimir --config.file=${conf}";
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
