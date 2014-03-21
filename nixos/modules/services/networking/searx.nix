{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.searx;

  configFile = cfg.configFile;

in

{

  ###### interface

  options = {

    services.searx = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the Searx server. See https://github.com/asciimoo/searx
        ";
      };

      configFile = mkOption {
        default = "";
        description = "
          The path of the Searx server configuration file. If no file
          is specified, a default file is used (default config file has
          debug mode enabled).
        ";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.searx.enable {

    users.extraUsers.searx =
      { uid = config.ids.uids.searx;
        description = "Searx user";
        createHome = true;
        home = "/var/lib/searx";
      };

    users.extraGroups.searx =
      { gid = config.ids.gids.searx;
      };

    systemd.services.searx =
      {
        description = "Searx server, the meta search engine.";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "searx";
          ExecStart = "${pkgs.pythonPackages.searx}/bin/searx-run";
        };
      } // (optionalAttrs (configFile != "") {
        environment.SEARX_SETTINGS_PATH = configFile;
      });
        

    environment.systemPackages = [ pkgs.pythonPackages.searx ];

  };

}
