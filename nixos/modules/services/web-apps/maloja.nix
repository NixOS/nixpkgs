{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.maloja;
  settingsFormat = pkgs.formats.ini;

 in {

  ###### interface

  options = {

    services.maloja = {

      enable = mkEnableOption "maloja";

      settings = mkOption {
        name = "settings";
        type = settingsFormat.type;
        default = {};
        description = ''
          Configuration for maloja, see
          <link xlink:href="https://github.com/krateng/maloja/blob/master/settings.md"/>
          for supported settings.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    services.maloja.settings = {
      skip_setup = true;
      timezone = mkDefault config.time.timeZone;
      directory_state = "/var/lib/maloja";
      directory_logs = "/var/log/maloja";
      directory_cache = "/var/cache/maloja";
    };

    environment.etc."maloja/settings.ini".source = settingsFormat.generate "settings.ini" cfg.settings;

    systemd.services.maloja = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      environment.MALOJA_DIRECTORY_CONFIG = "/etc/maloja";
      serviceConfig = {
        DynamicUser = true;
        DataDirectory = "maloja";
        StateDirectory = "maloja";
        LogsDirectory = "maloja";
        CacheDirectory = "maloja";
        ExecStart = "${pkgs.maloja}/bin/maloja run";
      };
    };
  };
}
