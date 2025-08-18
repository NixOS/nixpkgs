{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.pyroscope;
  settingsFormat = pkgs.formats.yaml { };
in
{
  meta.maintainers = [ lib.maintainers.kashw2 ];

  options.services.pyroscope = {
    enable = lib.mkEnableOption "Pyroscope";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether or not to open the firewall for this service";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          server = {
            http_listen_address = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "The server listen address";
            };
            http_listen_port = lib.mkOption {
              type = lib.types.int;
              default = 4040;
              description = "The port that Pyroscope should run on";
            };
          };
        };
      };
      default = {

      };
      description = ''
        Specify the configuration for Pyroscope in Nix.

        See <https://grafana.com/docs/pyroscope/latest/configure-server/reference-configuration-parameters/> for available options.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Specify a path to a configuration file that Pyroscope should use.";
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional flags to pass to the `ExecStart=` in `pyroscope.service`.";
    };
  };

  config = lib.mkIf cfg.enable {

    # Pyroscope and it's CLI
    environment.systemPackages = [ pkgs.pyroscope ];

    assertions = [
      {
        assertion = ((cfg.settings == { }) != (cfg.configFile == null));
        message = ''
          Please specify a configuration for Pyroscope with either
          'services.pyroscope.settings' or
          'services.pyroscope.configFile'.
        '';
      }
    ];

    systemd.services.pyroscope = {
      description = "Grafana Pyroscope Service Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        let
          conf =
            if cfg.configFile == null then
              settingsFormat.generate "config.yaml" cfg.settings
            else
              cfg.configFile;
        in
        {
          ExecStart = "${lib.getExe pkgs.pyroscope} --config.file=${conf} ${lib.escapeShellArgs cfg.extraFlags}";
          DynamicUser = true;
          ProtectSystem = "full";
          DevicePolicy = "closed";
          WorkingDirectory = "/var/lib/pyroscope";
          StateDirectory = "pyroscope";
          Restart = "on-failure";
        };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.settings.server.http_listen_port
    ];

  };

}
