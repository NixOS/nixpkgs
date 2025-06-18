# SVN server
{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.svnserve;

in

{

  ###### interface

  options = {

    services.svnserve = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable svnserve to serve Subversion repositories through the SVN protocol.";
      };

      svnBaseDir = lib.mkOption {
        type = lib.types.str;
        default = "/repos";
        description = "Base directory from which Subversion repositories are accessed.";
      };
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    systemd.services.svnserve = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = "mkdir -p ${cfg.svnBaseDir}";
      script = "${pkgs.subversion.out}/bin/svnserve -r ${cfg.svnBaseDir} -d --foreground --pid-file=/run/svnserve.pid";
    };
  };
}
