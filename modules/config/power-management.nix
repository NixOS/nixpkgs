{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.powerManagement;

in

{

  ###### interface

  options = {

    powerManagement = {

      enable = mkOption {
        default = true;
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

    boot.kernelModules =
      [ "acpi_cpufreq" "cpufreq_performance" "cpufreq_powersave" "cpufreq_ondemand"
        "cpufreq_conservative"
      ];

    powerManagement.cpuFreqGovernor = mkDefault "ondemand";
    powerManagement.scsiLinkPolicy = mkDefault "min_power";

    # Service executed before suspending/hibernating.
    systemd.services."pre-sleep" =
      { description = "Pre-Sleep Actions";
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        script =
          ''
            ${cfg.powerDownCommands}
          '';
        serviceConfig.Type = "oneshot";
      };

    # Service executed before suspending/hibernating.  There doesn't
    # seem to be a good way to hook in a service to be executed after
    # both suspend *and* hibernate, so have a separate one for each.
    systemd.services."post-suspend" =
      { description = "Post-Suspend Actions";
        wantedBy = [ "suspend.target" ];
        after = [ "systemd-suspend.service" ];
        script =
          ''
            ${cfg.resumeCommands}
            ${cfg.powerUpCommands}
          '';
        serviceConfig.Type = "oneshot";
      };

    systemd.services."post-hibernate" =
      { description = "Post-Hibernate Actions";
        wantedBy = [ "hibernate.target" ];
        after = [ "systemd-hibernate.service" ];
        script =
          ''
            ${cfg.resumeCommands}
            ${cfg.powerUpCommands}
          '';
        serviceConfig.Type = "oneshot";
      };

  };

}
