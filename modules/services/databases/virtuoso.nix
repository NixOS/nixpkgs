{ config, pkgs, ... }:
let
  cfg = config.services.virtuoso;
  virtuosoUser = "virtuoso";
  stateDir = "/var/lib/virtuoso";
in
with pkgs.lib;
{

  ###### interface

  options = {

    services.virtuoso = {

      enable = mkOption {
        default = false;
        description = "Whether to enable Virtuoso Opensource database server.";
      };

      config = mkOption {
        default = "";
        description = "Extra options to put into Virtuoso configuration file.";
      };

      parameters = mkOption {
        default = "";
        description = "Extra options to put into [Parameters] section of Virtuoso configuration file.";
      };

      listenAddress = mkOption {
	default = "1111";
	example = "myserver:1323";
        description = "ip:port or port to listen on.";
      };

      httpListenAddress = mkOption {
	default = null;
	example = "myserver:8080";
        description = "ip:port or port for Virtuoso HTTP server to listen on.";
      };

      dirsAllowed = mkOption {
	default = null;
	example = "/www, /home/";
        description = "A list of directories Virtuoso is allowed to access";
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = virtuosoUser;
        uid = config.ids.uids.virtuoso;
        description = "virtuoso user";
        home = stateDir;
      };

    jobs.virtuoso = {
      name = "virtuoso";
      startOn = "filesystem";

      preStart = ''
	mkdir -p ${stateDir}
	chown ${virtuosoUser} ${stateDir}
      '';

      script = ''
	cd ${stateDir}
	${pkgs.virtuoso}/bin/virtuoso-t +foreground +configfile ${pkgs.writeText "virtuoso.ini" cfg.config}
      '';
    };

    services.virtuoso.config = ''
      [Database]
      DatabaseFile=${stateDir}/x-virtuoso.db
      TransactionFile=${stateDir}/x-virtuoso.trx
      ErrorLogFile=${stateDir}/x-virtuoso.log
      xa_persistent_file=${stateDir}/x-virtuoso.pxa

      [Parameters]
      ServerPort=${cfg.listenAddress}
      RunAs=${virtuosoUser}
      ${optionalString (cfg.dirsAllowed != null) "DirsAllowed=${cfg.dirsAllowed}"}
      ${cfg.parameters}

      [HTTPServer]
      ${optionalString (cfg.httpListenAddress != null) "ServerPort=${cfg.httpListenAddress}"}
    '';

  };

}
