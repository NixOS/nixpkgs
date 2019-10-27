{ config, lib, ... }:

with lib;

let

  cfg = config.powerManagement;

in

{

  ###### interface

  options = {

    powerManagement = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description =
          ''
            Whether to enable power management.  This includes support
            for suspend-to-RAM and powersave features on laptops.
          '';
      };

      resumeCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Commands executed after the system resumes from suspend-to-RAM.";
      };

      powerUpCommands = mkOption {
        type = types.lines;
        default = "";
        example = literalExample ''
          "''${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda"
        '';
        description =
          ''
            Commands executed when the machine powers up.  That is,
            they're executed both when the system first boots and when
            it resumes from suspend or hibernation.
          '';
      };

      powerDownCommands = mkOption {
        type = types.lines;
        default = "";
        example = literalExample ''
          "''${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda"
        '';
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

    systemd.targets.post-resume = {
      description = "Post-Resume Actions";
      requires = [ "post-resume.service" ];
      after = [ "post-resume.service" ];
      wantedBy = [ "sleep.target" ];
      unitConfig.StopWhenUnneeded = true;
    };

    # Service executed before suspending/hibernating.
    systemd.services.pre-sleep =
      { description = "Pre-Sleep Actions";
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        script =
          ''
            ${cfg.powerDownCommands}
          '';
        serviceConfig.Type = "oneshot";
      };

    systemd.services.post-resume =
      { description = "Post-Resume Actions";
        after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
        script =
          ''
            ${config.systemd.package}/bin/systemctl try-restart post-resume.target
            ${cfg.resumeCommands}
            ${cfg.powerUpCommands}
          '';
        serviceConfig.Type = "oneshot";
      };

  };

}
