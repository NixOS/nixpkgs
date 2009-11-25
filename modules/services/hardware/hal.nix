# HAL daemon.
{ config, pkgs, ... }:

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

    environment.systemPackages = [ hal ];

    services.hal.packages = [ hal pkgs.hal_info ];

    users.extraUsers = singleton
      { name = "haldaemon";
        uid = config.ids.uids.haldaemon;
        description = "HAL daemon user";
      };

    users.extraGroups = singleton
      { name = "haldaemon";
        gid = config.ids.gids.haldaemon;
      };

    jobs.hal =
      { description = "HAL daemon";
        
        startOn = "started dbus" + optionalString config.services.acpid.enable " and started acpid";

        environment =
          { # !!! HACK? These environment variables manipulated inside
            # 'src'/hald/mmap_cache.c are used for testing the daemon.
            HAL_FDI_SOURCE_PREPROBE = "${fdi}/share/hal/fdi/preprobe";
            HAL_FDI_SOURCE_INFORMATION = "${fdi}/share/hal/fdi/information";
            HAL_FDI_SOURCE_POLICY = "${fdi}/share/hal/fdi/policy";

            # Stuff needed by the shell scripts run by HAL (in particular pm-utils).
            HALD_RUNNER_PATH = concatStringsSep ":"
              [ "${pkgs.coreutils}/bin"
                "${pkgs.gnugrep}/bin"
                "${pkgs.dbus.tools}/bin"
                "${pkgs.procps}/bin"
                "${pkgs.procps}/sbin"
                "${config.system.sbin.modprobe}/sbin"
                "${pkgs.module_init_tools}/bin"
                "${pkgs.module_init_tools}/sbin"
                "${pkgs.kbd}/bin"
              ];
          };

        preStart =
          ''
            mkdir -m 0755 -p /var/cache/hald
            mkdir -m 0755 -p /var/run/hald
            
            rm -f /var/cache/hald/fdi-cache
          '';

        daemonType = "fork";

        # The `PATH=' works around a bug in HAL: it concatenates
        # its libexec directory to $PATH, but using a 512-byte
        # buffer.  So if $PATH is too long it fails.
        script = "PATH= exec ${hal}/sbin/hald --use-syslog";
      };

    services.udev.packages = [hal];

    services.dbus.enable = true;
    services.dbus.packages = [hal];
    
  };

}
