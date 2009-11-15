{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.powerManagement;

  sleepHook = pkgs.writeScript "sleep-hook.sh"
    ''
      #! ${pkgs.stdenv.shell}
      action="$1"
      if [ "$action" = "resume" ]; then
          ${cfg.resumeCommands}        
      fi
    '';

in

{

  ###### interface

  options = {
  
    powerManagement = {

      enable = mkOption {
        default = false;
        description =
          ''
            Whether to enable power management.  This includes support
            for suspend-to-RAM and powersave features on laptops.
          '';
      };

      resumeCommands = mkOption {
        default = "";
        description = "Commands executed after the system resumes from suspend-to-RAM.";
      };
      
    };
    
  };
  

  ###### implementation

  config = mkIf cfg.enable {

    # Enable the ACPI daemon.  Not sure whether this is essential.
    services.acpid.enable = true;

    environment.systemPackages = [ pkgs.pmutils ];

    environment.etc = singleton
      { source = sleepHook;
        target = "pm/sleep.d/00sleep-hook";
      };
    
  };

}
