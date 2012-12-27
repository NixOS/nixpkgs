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

    boot.systemd.services.nscd =
      { description = "Name Service Cache Daemon";

        wantedBy = [ "nss-lookup.target" "nss-user-lookup.target" ];

        environment = { LD_LIBRARY_PATH = nssModulesPath; };

        preStart =
          ''
            mkdir -m 0755 -p /run/nscd
            rm -f /run/nscd/nscd.pid
            mkdir -m 0755 -p /var/db/nscd
          '';

        serviceConfig =
          { ExecStart = "@${pkgs.glibc}/sbin/nscd nscd -f ${./nscd.conf}";
            Type = "forking";
            PIDFile = "/run/nscd/nscd.pid";
            Restart = "always";
            ExecReload =
              [ "${pkgs.glibc}/sbin/nscd --invalidate passwd"
                "${pkgs.glibc}/sbin/nscd --invalidate group"
                "${pkgs.glibc}/sbin/nscd --invalidate hosts"
              ];
          };
      };

  };
}
