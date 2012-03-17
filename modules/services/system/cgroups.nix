{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.cgroups;

  cgconfigConf = pkgs.writeText "cgconfig.conf" cfg.groups;

  cgrulesConf = pkgs.writeText "cgrules.conf" cfg.rules;

in

{

  ###### interface

  options = {

    services.cgroups.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable support for control groups, a Linux kernel
        feature for resource management.  It allows you to assign
        processes to groups that share certain resource limits (e.g.,
        CPU or memory).  The <command>cgrulesengd</command> daemon
        automatically assigns processes to the right cgroup depending
        on the rules defined in
        <option>services.cgroups.rules</option>.
      '';
    };

    services.cgroups.groups = mkOption {
      type = types.string;
      default =
        ''
          mount {
            cpu = /dev/cgroup/cpu;
          }
        '';
      example =
        ''
          mount {
            cpu = /dev/cgroup/cpu;
            cpuacct = /dev/cgroup/cpuacct;
          }

          # Create a "www" cgroup with a lower share of the CPU (the
          # default is 1024).
          group www {
            cpu {
              cpu.shares = "500";
            }
          }
        '';
      description = ''
        The contents of the <filename>cgconfig.conf</filename>
        configuration file, which defines the cgroups.
      '';
    };

    services.cgroups.rules = mkOption {
      type = types.string;
      default = "";
      example =
        ''
          # All processes executed by the "wwwrun" uid should be
          # assigned to the "www" CPU cgroup.
          wwwrun cpu www
        '';
      description = ''
        The contents of the <filename>cgrules.conf</filename>
        configuration file, which determines to which cgroups
        processes should be assigned by the
        <command>cgrulesengd</command> daemon.
      '';
    };

  };

  
  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.libcgroup ];

    environment.etc =
      [ { source = cgconfigConf;
          target = "cgconfig.conf";
        }
        { source = cgrulesConf;
          target = "cgrules.conf";
        }
      ];

    # The daemon requires the userspace<->kernelspace netlink
    # connector.
    boot.kernelModules = [ "cn" ];
    
    jobs.cgroups =
      { startOn = "startup";

        description = "Control groups daemon";

        path = [ pkgs.libcgroup pkgs.procps ];
      
        preStart =
          ''
            cgclear || true

            # Mount the cgroup hierarchies.  Note: we refer to the
            # store path of cgconfig.conf here to ensure that the job
            # gets reloaded if the configuration changes.
            cgconfigparser -l ${cgconfigConf}

            # Move existing processes to the right cgroup.
            cgclassify --cancel-sticky $(ps --no-headers -eL o tid) || true

            # Force a restart if the rules change:
            # ${cgrulesConf}
          '';

        # Run the daemon that moves new processes to the right cgroup.
        exec = "cgrulesengd";

        daemonType = "fork";

        postStop =
          ''
            cgclear
          '';
      };
      

  };

}
