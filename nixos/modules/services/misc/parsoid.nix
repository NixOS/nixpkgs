{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.parsoid;

  conf = ''
    exports.setup = function( parsoidConfig ) {
      ${toString (mapAttrsToList (name: str: "parsoidConfig.setInterwiki('${name}', '${str}');") cfg.interwikis)}

      parsoidConfig.serverInterface = "${cfg.interface}";
      parsoidConfig.serverPort = ${toString cfg.port};

      parsoidConfig.useSelser = true;

      ${cfg.extraConfig}
    };
  '';

  confFile = builtins.toFile "localsettings.js" conf;

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

      interwikis = mkOption {
        type = types.attrsOf types.str;
        example = { localhost = "http://localhost/api.php"; };
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
        type = types.lines;
        default = "";
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
        ExecStart = "${pkgs.nodePackages.parsoid}/lib/node_modules/parsoid/api/server.js -c ${confFile} -n ${toString cfg.workers}";
      };
    };

  };

}
