{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.autobrr;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "autobrr.toml" cfg.settings;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "autobrr" "secretFile" ] ''
      The services.autobrr.secretFile option has been removed.
      Instead, please provide this secret by setting the
      AUTOBRR__SESSION_SECRET environment variable using
      services.autobrr.environmentFile.
    '')
  ];

  options = {
    services.autobrr = {
      enable = lib.mkEnableOption "Autobrr";

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Autobrr web interface.";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Environment file to be passed to the systemd service. Useful for
          passing secrets to the service.

          Refer to
          <https://autobrr.com/installation/docker#environment-variables> for a
          list of environment variables.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = configFormat.type; };
        default = {
          host = "127.0.0.1";
          port = 7474;
          checkForUpdates = true;
        };
        example = {
          logLevel = "DEBUG";
        };
        description = ''
          Autobrr configuration options.

          Refer to <https://autobrr.com/configuration/autobrr>
          for a full list.
        '';
      };

      package = lib.mkPackageOption pkgs "autobrr" { };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? sessionSecret);
        message = ''
          Session secrets should not be passed via settings, as
          these are stored in the world-readable nix store.

          Use the environmentFile option to set the AUTOBRR__SESSION_SECRET
          variable instead.'';
      }
    ];

    systemd.services.autobrr = {
      description = "Autobrr";
      after = [
        "syslog.target"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "autobrr";
        ExecStart = "${lib.getExe cfg.package} --config ${configFile}";
        Restart = "on-failure";
        EnvironmentFile = cfg.environmentFile;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.port ]; };
  };
}
