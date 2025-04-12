{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.peroxide;
  settingsFormat = pkgs.formats.yaml { };
  stateDir = "peroxide";
in
{
  options.services.peroxide = {
    enable = mkEnableOption "peroxide";

    package = mkPackageOption pkgs "peroxide" {
      default = [ "peroxide" ];
    };

    logLevel = mkOption {
      # https://github.com/sirupsen/logrus#level-logging
      type = types.enum [
        "Panic"
        "Fatal"
        "Error"
        "Warning"
        "Info"
        "Debug"
        "Trace"
      ];
      default = "Warning";
      example = "Info";
      description = "Only log messages of this priority or higher.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          UserPortImap = mkOption {
            type = types.port;
            default = 1143;
            description = "The port on which to listen for IMAP connections.";
          };

          UserPortSmtp = mkOption {
            type = types.port;
            default = 1025;
            description = "The port on which to listen for SMTP connections.";
          };

          ServerAddress = mkOption {
            type = types.str;
            default = "[::0]";
            example = "localhost";
            description = "The address on which to listen for connections.";
          };
        };
      };
      default = { };
      description = ''
        Configuration for peroxide.  See
        [config.example.yaml](https://github.com/ljanyst/peroxide/blob/master/config.example.yaml)
        for an example configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.peroxide.settings = {
      # peroxide deletes the cache directory on startup, which requires write
      # permission on the parent directory, so we can't use
      # /var/cache/peroxide
      CacheDir = "/var/cache/peroxide/cache";
      X509Key = mkDefault "/var/lib/${stateDir}/key.pem";
      X509Cert = mkDefault "/var/lib/${stateDir}/cert.pem";
      CookieJar = "/var/lib/${stateDir}/cookies.json";
      CredentialsStore = "/var/lib/${stateDir}/credentials.json";
    };

    users.users.peroxide = {
      isSystemUser = true;
      group = "peroxide";
    };
    users.groups.peroxide = { };

    systemd.services.peroxide = {
      description = "Peroxide ProtonMail bridge";
      requires = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      restartTriggers = [ config.environment.etc."peroxide.conf".source ];

      serviceConfig = {
        Type = "simple";
        User = "peroxide";
        LogsDirectory = "peroxide";
        LogsDirectoryMode = "0750";
        # Specify just "peroxide" so that the user has write permission, because
        # peroxide deletes and recreates the cache directory on startup.
        CacheDirectory = [
          "peroxide"
          "peroxide/cache"
        ];
        CacheDirectoryMode = "0700";
        StateDirectory = stateDir;
        StateDirectoryMode = "0700";
        ExecStart = "${cfg.package}/bin/peroxide -log-file=/var/log/peroxide/peroxide.log -log-level ${cfg.logLevel}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };

      preStart = ''
        # Create a self-signed certificate if no certificate exists.
        if [[ ! -e "${cfg.settings.X509Key}" && ! -e "${cfg.settings.X509Cert}" ]]; then
            ${cfg.package}/bin/peroxide-cfg -action gen-x509 \
              -x509-org 'N/A' \
              -x509-cn 'nixos' \
              -x509-cert "${cfg.settings.X509Cert}" \
              -x509-key "${cfg.settings.X509Key}"
        fi
      '';
    };

    # https://github.com/ljanyst/peroxide/blob/master/peroxide.logrotate
    services.logrotate.settings.peroxide = {
      files = "/var/log/peroxide/peroxide.log";
      rotate = 31;
      frequency = "daily";
      compress = true;
      delaycompress = true;
      missingok = true;
      notifempty = true;
      su = "peroxide peroxide";
      postrotate = "systemctl reload peroxide";
    };

    environment.etc."peroxide.conf".source = settingsFormat.generate "peroxide.conf" cfg.settings;
    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with maintainers; [
    aanderse
    aidalgol
  ];
}
