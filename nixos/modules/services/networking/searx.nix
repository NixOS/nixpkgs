{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.searx;

  configFile = cfg.configFile;

in

{

  ###### interface

  options = {

    services.searx = {

      enable = mkEnableOption
        "the searx server. See https://github.com/asciimoo/searx";

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "
          The path of the Searx server configuration file. If no file
          is specified, a default file is used (default config file has
          debug mode enabled).
        ";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.pythonPackages.searx;
        defaultText = "pkgs.pythonPackages.searx";
        description = "searx package to use.";
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
          ExecStart = "${cfg.package}/bin/searx-run";
        };
      } // (optionalAttrs (configFile != null) {
        environment.SEARX_SETTINGS_PATH = configFile;
      });

    environment.systemPackages = [ cfg.package ];

  };

}
