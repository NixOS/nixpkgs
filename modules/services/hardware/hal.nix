# HAL daemon.
{pkgs, config, ...}:

with pkgs.lib;

let

  cfg = config.services.hal;

  inherit (pkgs) hal;

  fdi =
    if cfg.extraFdi == [] then
      "${hal}/share/hal/fdi"
    else
      pkgs.buildEnv {
        name = "hal-fdi";
        pathsToLink = [ "/preprobe" "/information" "/policy" ];
        paths = [ "${hal}/share/hal/fdi" ] ++ cfg.extraFdi;
      };

in

{

  ###### interface
  
  options = {
  
    services.hal = {
    
      enable = mkOption {
        default = true;
        description = "
          Whether to start the HAL daemon.
        ";
      };

      extraFdi = mkOption {
        default = [];
        example = [ "/nix/store/.../fdi" ];
        description = "
          Extend HAL daemon configuration with additionnal paths.
        ";
      };

    };
    
  };


  ###### implementation
  
  config = mkIf cfg.enable {

    environment.systemPackages = [hal];

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
          { HAL_FDI_SOURCE_PREPROBE = "${fdi}/preprobe";
            HAL_FDI_SOURCE_INFORMATION = "${fdi}/information";
            HAL_FDI_SOURCE_POLICY = "${fdi}/policy";
          };

        preStart =
          ''
            mkdir -m 0755 -p /var/cache/hald
            
            rm -f /var/cache/hald/fdi-cache
          '';

        exec = "${hal}/sbin/hald --daemon=no";
      };

    services.udev.addUdevPkgs = [hal];

    services.dbus.enable = true;
    services.dbus.packages = [hal];
    
  };

}