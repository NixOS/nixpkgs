{pkgs, config, ...}:

with pkgs.lib;

let

  nssModulesPath = config.system.nssModules.path;

  inherit (pkgs.lib) singleton;

in

{

  ###### interface

  options = {

    services.nscd = {

      enable = mkOption {
        default = true;
        description = "Whether to enable the Name Service Cache Daemon.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.nscd.enable {

    users.extraUsers = singleton
      { name = "nscd";
        uid = config.ids.uids.nscd;
        description = "Name service cache daemon user";
      };

    jobs.nscd =
      { description = "Name Service Cache Daemon";

        startOn = "startup";

        environment = { LD_LIBRARY_PATH = nssModulesPath; };

        preStart =
          ''
            mkdir -m 0755 -p /run/nscd
            rm -f /run/nscd/nscd.pid
            mkdir -m 0755 -p /var/db/nscd
          '';

        path = [ pkgs.glibc ];

        exec = "nscd -f ${./nscd.conf}";

        daemonType = "fork";

        serviceConfig =
          ''
            PIDFile=/run/nscd/nscd.pid
            ExecReload=${pkgs.glibc}/sbin/nscd --invalidate hosts
          '';
      };

  };
}
