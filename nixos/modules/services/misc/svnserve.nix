# SVN server
{ config, lib, pkgs, ... }:

with lib;

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
    systemd.services.svnserve = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = "mkdir -p ${cfg.svnBaseDir}";
      script = "${pkgs.subversion.out}/bin/svnserve -r ${cfg.svnBaseDir} -d --foreground --pid-file=/run/svnserve.pid";
    };
  };
}
