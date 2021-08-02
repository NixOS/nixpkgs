{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.autosuspend;
  settingsFormat = pkgs.formats.ini {};
in {
  options.services.autosuspend = {
    enable = mkEnableOption "the autosuspend service";

    settings = mkOption {
      type = settingsFormat.type;
      default = {};
      description = ''
        Configuration for autosuspend, see
        <link xlink:href="https://autosuspend.readthedocs.io/en/latest/configuration_file.html"/>
        for supported settings.
      '';
    };

    loggingSettings = mkOption {
      type = settingsFormat.type;
      default = {};
      description = ''
        Configuration for autosuspend logs, see
        <link xlink:href="https://autosuspend.readthedocs.io/en/latest/configuration_file.html"/>
        for supported settings.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc."autosuspend.conf".source =
      settingsFormat.generate "autosuspend.conf" cfg.settings;

    environment.etc."autosuspend-logging.conf".source =
      settingsFormat.generate "autosuspend-logging.conf" cfg.loggingSettings;

    systemd = {
      packages = [ pkgs.autosuspend ];
      # https://github.com/NixOS/nixpkgs/issues/81138
      services.autosuspend.wantedBy = [ "multi-user.target" ];
    };
  };
}
