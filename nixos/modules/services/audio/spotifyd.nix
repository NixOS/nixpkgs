{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.spotifyd;

  configFile = writeFile "spotifyd.cfg" cfg.config;

in {
  options = {

    services.spotifyd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable spotifyd.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.spotifyd;
        defaultText = "pkgs.spotifyd";
        description = "Spotifyd package to use.";
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = "Configuration of spotifyd. See https://github.com/Spotifyd/spotifyd#configuration";
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.spotifyd = {
      after = [ "network.target" ];
      description = "Spotify daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "spotifyd";
        Type = "forking";
        ExecStart = "${cfg.package}/bin/spotifyd --config ${configFile}";
      };
    };

    users = {
      users.spotifyd = {
        description = "spotifyd daemon user";
        home = cfg.dataDir;
        group = "spotifyd";
      };
      groups.spotifyd = {};
    };
  };

}

