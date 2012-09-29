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
        description = "
          Whether to enable the Name Service Cache Daemon.
        ";
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
            mkdir -m 0755 -p /var/run/nscd
            mkdir -m 0755 -p /var/db/nscd
          '';

        path = [ pkgs.glibc ];

        exec = "nscd -f ${./nscd.conf} -d 2> /dev/null";
      };

    # Flush nscd's ‘hosts’ database when the network comes up or the
    # system configuration changes to get rid of any negative entries.
    jobs.invalidate_nscd =
      { name = "invalidate-nscd";
        description = "Invalidate NSCD cache";
        startOn = "ip-up or config-changed";
        task = true;
        path = [ pkgs.glibc ];
        script = ''
          nscd --invalidate=passwd
          nscd --invalidate=group
          nscd --invalidate=hosts
        '';
      };

  };
}
