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
  options = {
    services.autobrr = {
      enable = lib.mkEnableOption "Autobrr";

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Autobrr web interface.";
      };

      secretFile = lib.mkOption {
        type = lib.types.path;
        description = "File containing the session secret for the Autobrr web interface.";
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

          Use the secretFile option instead.'';
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
        LoadCredential = "sessionSecret:${cfg.secretFile}";
        Environment = [ "AUTOBRR__SESSION_SECRET_FILE=%d/sessionSecret" ];
        StateDirectory = "autobrr";
        preStart = ''
          install -D -m 600 -o %u -g %g '${configFile}' '%S/autobrr/config.toml'
        '';
        ExecStart = "${lib.getExe cfg.package} --config %S/autobrr";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.port ]; };
  };
}
