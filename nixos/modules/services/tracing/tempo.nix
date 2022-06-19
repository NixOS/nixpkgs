{ config, lib, pkgs, ... }:

let
  inherit (lib) escapeShellArgs mkEnableOption mkIf mkOption types;

  cfg = config.services.tempo;

  settingsFormat = pkgs.formats.yaml {};
in {
  options.services.tempo = {
    enable = mkEnableOption "Grafana Tempo";

    configuration = mkOption {
      type = (pkgs.formats.json {}).type;
      default = {};
      description = ''
        Specify the configuration for Tempo in Nix.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Specify a path to a configuration file that Tempo should use.
      '';
    };
  };

  config = mkIf cfg.enable {
    # for tempo-cli and friends
    environment.systemPackages = [ pkgs.tempo ];

    assertions = [{
      assertion = (
        (cfg.configuration == {} -> cfg.configFile != null) &&
        (cfg.configFile != null -> cfg.configuration == {})
      );
      message  = ''
        Please specify either
        'services.tempo.configuration' or
        'services.tempo.configFile'.
      '';
    }];

    systemd.services.tempo = {
      description = "Grafana Tempo Service Daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        conf = if cfg.configFile == null
               then settingsFormat.generate "config.yaml" cfg.configuration
               else cfg.configFile;
      in
      {
        ExecStart = "${pkgs.tempo}/bin/tempo --config.file=${conf}";
        DynamicUser = true;
        Restart = "always";
        ProtectSystem = "full";
        DevicePolicy = "closed";
        NoNewPrivileges = true;
        WorkingDirectory = "/var/lib/tempo";
        StateDirectory = "tempo";
      };
    };
  };
}
