# HAL daemon.
{pkgs, config, ...}:

with pkgs.lib;

let

  cfg = config.services.hal;

  inherit (pkgs) hal;

  fdi = pkgs.buildEnv {
    name = "hal-fdi";
    pathsToLink = [ "/share/hal/fdi" ];
    paths = cfg.packages;
  };

in

{

  ###### interface
  
  options = {
  
    services.hal = {
    
      enable = mkOption {
        default = true;
        description = ''
          Whether to start the HAL daemon.
        '';
      };

      packages = mkOption {
        default = [];
        description = ''
          Packages containing additional HAL configuration data.
        '';
      };

    };
    
  };


  ###### implementation
  
  config = mkIf cfg.enable {

    environment.systemPackages = [hal];

    services.hal.packages = [hal pkgs.hal_info];

    users.extraUsers = singleton
      { name = "haldaemon";
        uid = config.ids.uids.haldaemon;
        description = "HAL daemon user";
      };

    users.extraGroups = singleton
      { name = "haldaemon";
        gid = config.ids.gids.haldaemon;
      };

    jobs = singleton
      { name = "hal";

        description = "HAL daemon";
        
        # !!! TODO: make sure that HAL starts after acpid,
        # otherwise hald-addon-acpi will grab /proc/acpi/event.
        startOn = if config.powerManagement.enable then "acpid" else "dbus";
        stopOn = "shutdown";

        # !!! HACK? These environment variables manipulated inside
        # 'src'/hald/mmap_cache.c are used for testing the daemon
        environment =
          { HAL_FDI_SOURCE_PREPROBE = "${fdi}/share/hal/fdi/preprobe";
            HAL_FDI_SOURCE_INFORMATION = "${fdi}/share/hal/fdi/information";
            HAL_FDI_SOURCE_POLICY = "${fdi}/share/hal/fdi/policy";
          };

        preStart =
          ''
            mkdir -m 0755 -p /var/cache/hald
            mkdir -m 0755 -p /var/run/hald
            
            rm -f /var/cache/hald/fdi-cache

            # !!! Hack: start the daemon here to make sure it's
            # running when the Upstart job reaches the "running"
            # state.  Should be fixable in Upstart 0.6.
            ${hal}/sbin/hald
          '';

        postStop =
          '' 
            pid=$(cat /var/run/hald/pid)
            test -n "$pid" && kill "$pid"
         '';
      };

    services.udev.packages = [hal];

    services.dbus.enable = true;
    services.dbus.packages = [hal];
    
  };

}