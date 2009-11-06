{ config, pkgs, ... }:

with pkgs.lib;

let

  acpiConfDir = pkgs.runCommand "acpi-events" {}
    ''
      ensureDir $out
      ${
        # Generate a .conf file for each event. (You can't have
        # multiple events in one config file...)
        let f = event:
          ''
            fn=$out/${event.name}.conf
            echo "event=${event.event}" > $fn
            echo "action=${pkgs.writeScript "${event.name}.sh" event.action}" >> $fn
          '';
        in pkgs.lib.concatMapStrings f events
      }
    '';
  
  events = [powerEvent lidEvent acEvent];
  
  # Called when the power button is pressed.
  powerEvent =
    { name = "power-button";
      event = "button/power.*";
      action = 
        ''
          #! ${pkgs.bash}/bin/sh
        '';
    };
  
  # Called when the laptop lid is opened/closed.
  lidEvent = 
    { name = "lid";
      event = "button/lid.*";
      action =
        ''
          #! ${pkgs.bash}/bin/sh
        '';
    };
  
  # Called when the AC power is connected or disconnected.
  acEvent =
    { name = "ac-power";
      event = "ac_adapter.*";
      action = 
        ''
          #! ${pkgs.bash}/bin/sh
        '';
    };

in

{

  ###### interface

  options = {
  
    powerManagement = {

      enable = mkOption {
        default = false;
        description = "Whether to enable power management (ACPI daemon)";
      };
      
    };
    
  };
  

  ###### implementation

  config = mkIf config.powerManagement.enable {

    jobs.acpid =
      { description = "ACPI daemon";

        startOn = "started udev";

        exec = "${pkgs.acpid}/sbin/acpid --foreground --confdir ${acpiConfDir}";
      };
      
  };
  
}
