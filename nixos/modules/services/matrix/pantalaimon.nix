{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.pantalaimon;
  settingsFormat = pkgs.formats.ini {};
  settingsFile = settingsFormat.generate "pantalaimon.conf" cfg.settings;
in
{
  options = {
    services.pantalaimon = {
      enable = mkEnableOption "Pantalaimon, a E2EE aware proxy daemon for Matrix clients";

      package = mkOption {
        type = types.package;
        default = pkgs.pantalaimon.override { enableDbusUi = false; };
        description = ''
          An overridable package specifying the package that Pantalaimon will
          use. Note, for this to work, you should not enable the DBUS UI in
          your derivation.
        '';
      };

      settings = mkOption rec {
        inherit (settingsFormat) type;
        description = ''
          Settings for the Pantalaimon daemon. See an example upstream:
          https://github.com/matrix-org/pantalaimon/blob/master/contrib/pantalaimon.conf
        '';
        example = {
          Default = {
            LogLevel = "Debug";
            Notifications = "Off";
          };

          local-matrix = {
            Homeserver = "http://localhost:8008";
            ListenAddress = "localhost";
            ListenPort = 8009;
            SSL = true;
            IgnoreVerification = false;
            UseKeyring = true;
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pantalaimon = {
      description = "Pantalaimon E2E Matrix reverse proxy";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ExecStart = ''
          ${cfg.package}/bin/pantalaimon --config=${settingsFile}
        '';
      };
    };
  };

  meta.maintainers = with maintainers; [ sumnerevans ];
}
