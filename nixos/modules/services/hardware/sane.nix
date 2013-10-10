{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    hardware.sane.enable = mkOption {
      default = false;
      description = "Enable support for SANE scanners.";
    };

    hardware.sane.snapshot = mkOption {
      default = false;
      description = "Use a development snapshot of SANE scanner drivers.";
    };

  };


  ###### implementation

    config = let pkg = if config.hardware.sane.snapshot
                          then pkgs.saneBackendsGit
                          else pkgs.saneBackends;
      in mkIf config.hardware.sane.enable {
           environment.systemPackages = [ pkg ];
           services.udev.packages = [ pkg ];
           
           users.extraGroups = singleton {
             name = "scanner";
             gid = config.ids.gids.scanner;
           };

      };

}
