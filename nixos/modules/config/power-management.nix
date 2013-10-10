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
      [ "acpi_cpufreq" "powernow-k8" "cpufreq_performance" "cpufreq_powersave" "cpufreq_ondemand"
        "cpufreq_conservative"
      ];

    powerManagement.cpuFreqGovernor = mkDefault "ondemand";
    powerManagement.scsiLinkPolicy = mkDefault "min_power";

    systemd.targets.post-resume = {
      description = "Post-Resume Actions";
      requires = [ "post-resume.service" ];
      after = [ "post-resume.service" ];
      wantedBy = [ "sleep.target" ];
      unitConfig.StopWhenUnneeded = true;
    };

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

    systemd.services."post-resume" =
      { description = "Post-Resume Actions";
        after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
        script =
          ''
            ${cfg.resumeCommands}
            ${cfg.powerUpCommands}
          '';
        serviceConfig.Type = "oneshot";
      };

  };

}
