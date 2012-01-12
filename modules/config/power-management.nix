{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.powerManagement;

  sleepHook = pkgs.writeScript "sleep-hook.sh"
    ''
      #! ${pkgs.stdenv.shell}
      action="$1"
      case "$action" in
          hibernate|suspend)
              ${cfg.powerDownCommands}
              ;;
          thaw|resume)
              ${cfg.resumeCommands}
              ${cfg.powerUpCommands}
              ;;
      esac
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

      powerUpCommands = mkOption {
        default = "";
        example = "${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda";
        description =
          ''
            Commands executed when the machine powers up.  That is,
            they're executed both when the system first boots and when
            it resumes from suspend or hibernation.
          '';
      };

      powerDownCommands = mkOption {
        default = "";
        example = "${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda";
        description =
          ''
            Commands executed when the machine powers down.  That is,
            they're executed both when the system shuts down and when
            it goes to suspend or hibernation.
          '';
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

    boot.kernelModules =
      [ "acpi_cpufreq" "cpufreq_performance" "cpufreq_powersave" "cpufreq_ondemand"
        "p4_clockmod"
      ];

    powerManagement.cpuFreqGovernor = "ondemand";
    powerManagement.scsiLinkPolicy = "min_power";
  };

}
