{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.services.tempo;

  settingsFormat = pkgs.formats.yaml {};
in {
  options.services.tempo = {
    enable = mkEnableOption (lib.mdDoc "Grafana Tempo");

    settings = mkOption {
      type = settingsFormat.type;
      default = {};
      description = lib.mdDoc ''
        Specify the configuration for Tempo in Nix.

        See https://grafana.com/docs/tempo/latest/configuration/ for available options.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Specify a path to a configuration file that Tempo should use.
      '';
    };
<<<<<<< HEAD

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [];
      example = lib.literalExpression
        ''
          [ "-config.expand-env=true" ]
        '';
      description = lib.mdDoc ''
        Additional flags to pass to the `ExecStart=` in `tempo.service`.
      '';
    };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  config = mkIf cfg.enable {
    # for tempo-cli and friends
    environment.systemPackages = [ pkgs.tempo ];

    assertions = [{
      assertion = (
        (cfg.settings == {}) != (cfg.configFile == null)
      );
      message  = ''
        Please specify a configuration for Tempo with either
        'services.tempo.settings' or
        'services.tempo.configFile'.
      '';
    }];

    systemd.services.tempo = {
      description = "Grafana Tempo Service Daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        conf = if cfg.configFile == null
               then settingsFormat.generate "config.yaml" cfg.settings
               else cfg.configFile;
      in
      {
<<<<<<< HEAD
        ExecStart = "${pkgs.tempo}/bin/tempo --config.file=${conf} ${lib.escapeShellArgs cfg.extraFlags}";
=======
        ExecStart = "${pkgs.tempo}/bin/tempo --config.file=${conf}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
