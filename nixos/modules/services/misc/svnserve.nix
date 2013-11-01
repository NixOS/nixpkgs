# SVN server
{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.svnserve;

in

{

  ###### interface

  options = {

    services.svnserve = {

      enable = mkOption {
        default = false;
        description = "Whether to enable svnserve to serve Subversion repositories through the SVN protocol.";
      };

      svnBaseDir = mkOption {
        default = "/repos";
	description = "Base directory from which Subversion repositories are accessed.";
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    jobs.svnserve = {
      startOn = "started network-interfaces";
      stopOn = "stopping network-interfaces";

      preStart = "mkdir -p ${cfg.svnBaseDir}";

      exec = "${pkgs.subversion}/bin/svnserve -r ${cfg.svnBaseDir} -d --foreground --pid-file=/var/run/svnserve.pid";
    };
  };
}
