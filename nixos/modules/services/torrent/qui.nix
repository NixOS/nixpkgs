{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    getExe
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;
  inherit (lib.types)
    bool
    path
    port
    str
    submodule
    ;
  cfg = config.services.qui;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "qui.toml" cfg.settings;
in
{
  options = {
    services.qui = {
      enable = mkEnableOption "qui";

      package = mkPackageOption pkgs "qui" { };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = "Open ports in the firewall for qui.";
      };

      secretFile = mkOption {
        type = path;
        description = "File containing the session secret.";
      };

      settings = mkOption {
        default = { };
        example = {
          port = 7777;
          logLevel = "DEBUG";
          metricsEnabled = true;
        };
        type = submodule {
          freeformType = configFormat.type;
          options = {
            host = mkOption {
              type = str;
              default = "127.0.0.1";
              description = "The host address qui listens on.";
            };

            port = mkOption {
              type = port;
              default = 7476;
              description = "The port qui listens on.";
            };
          };
        };
        description = ''
          qui configuration options.

          Refer to the [template config](https://github.com/autobrr/qui/blob/main/internal/config/config.go#L268)
          or the [configuration documentation](https://github.com/autobrr/qui?tab=readme-ov-file#configuration)
          for the available options.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? sessionSecret);
        message = ''
          Session secrets should not be passed via settings, as
          these are stored in the world-readable nix store.

          Use the secretFile option instead.'';
      }
    ];

    systemd.services.qui = {
      description = "qui: alternative qBittorrent webUI";
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
        Environment = [ "QUI__SESSION_SECRET_FILE=%d/sessionSecret" ];
        StateDirectory = "qui";
        ExecStartPre = ''
          ${pkgs.coreutils}/bin/install -m 600 '${configFile}' '%S/qui/config.toml'
        '';
        ExecStart = "${getExe cfg.package} serve --config-dir %S/qui";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };
  };

  meta.maintainers = with maintainers; [ undefined-landmark ];
}
