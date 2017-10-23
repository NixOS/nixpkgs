{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.parsoid;

  confTree = {
    worker_heartbeat_timeout = 300000;
    logging = { level = "info"; };
    services = [{
      module = "lib/index.js";
      entrypoint = "apiServiceWorker";
      conf = {
        mwApis = map (x: if isAttrs x then x else { uri = x; }) cfg.wikis;
        serverInterface = cfg.interface;
        serverPort = cfg.port;
      };
    }];
  };

  confFile = pkgs.writeText "config.yml" (builtins.toJSON (recursiveUpdate confTree cfg.extraConfig));

in
{
  ##### interface

  options = {

    services.parsoid = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Parsoid -- bidirectional
          wikitext parser.
        '';
      };

      wikis = mkOption {
        type = types.listOf (types.either types.str types.attrs);
        example = [ "http://localhost/api.php" ];
        description = ''
          Used MediaWiki API endpoints.
        '';
      };

      workers = mkOption {
        type = types.int;
        default = 2;
        description = ''
          Number of Parsoid workers.
        '';
      };

      interface = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          Interface to listen on.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 8000;
        description = ''
          Port to listen on.
        '';
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Extra configuration to add to parsoid configuration.
        '';
      };

    };

  };

  ##### implementation

  config = mkIf cfg.enable {

    systemd.services.parsoid = {
      description = "Bidirectional wikitext parser";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = "nobody";
        ExecStart = "${pkgs.nodePackages.parsoid}/lib/node_modules/parsoid/bin/server.js -c ${confFile} -n ${toString cfg.workers}";
      };
    };

  };

}
