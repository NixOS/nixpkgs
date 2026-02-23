{ config, lib, ... }:
let

  cfg = config.powerManagement;

in

{

  ###### interface

  options = {

    powerManagement = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable power management.  This includes support
          for suspend-to-RAM and powersave features on laptops.
        '';
      };

      resumeCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = lib.literalExpression ''
          "''${pkgs.util-linux}/bin/rfkill unblock all"
        '';
        description = "Commands executed after the system resumes from suspend-to-RAM.";
      };

      powerUpCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = lib.literalExpression ''
          "''${pkgs.powertop}/bin/powertop --auto-tune"
        '';
        description = ''
          Commands executed when the machine powers up.  That is,
          they're executed both when the system first boots and when
          it resumes from suspend or hibernation.
        '';
      };

      powerDownCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = lib.literalExpression ''
          "''${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda"
        '';
        description = ''
          Commands executed when the machine powers down.  That is,
          they're executed both when the system shuts down and when
          it goes to suspend or hibernation.
        '';
      };

      bootCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = lib.literalExpression ''
          "''${pkgs.networkmanager}/bin/nmcli radio wifi on"
        '';
        description = ''
          Commands executed only once after initial boot.
          These commands are executed before `powerUpCommands`.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    warnings = lib.optional (cfg.powerUpCommands != "") ''
      powerManagement.powerUpCommands is deprecated due to it having unclear ordering semantics.
      It will be removed in NixOS 26.11.
      It is recommended to create an explicit systemd oneshot service instead,
      that is pulled in at the right time during the boot process.
      See https://www.freedesktop.org/software/systemd/man/latest/systemd.special.html
      for more information on possible targets that can be used for this.

      If you also want to run this service upon waking up from resume, the recommended
      method to do so is described here:
      https://www.freedesktop.org/software/systemd/man/latest/systemd.special.html#sleep.target
    '';

    systemd.targets.post-resume = {
      description = "Post-Resume Actions";
      requires = [ "post-resume.service" ];
      after = [ "post-resume.service" ];
      wantedBy = [ "sleep.target" ];
      unitConfig.StopWhenUnneeded = true;
    };

    systemd.services = {
      # Service executed before suspending/hibernating.
      pre-sleep = {
        description = "Pre-Sleep Actions";
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        script = cfg.powerDownCommands;
        serviceConfig.Type = "oneshot";
      };

      # Service executed after resuming from suspend/hibernate
      post-resume = {
        description = "Post-Resume Actions";
        # Pulled in by post-resume.service above
        after = [ "sleep.target" ];
        script = ''
          /run/current-system/systemd/bin/systemctl try-restart --no-block post-resume.target
          ${cfg.resumeCommands}
          ${cfg.powerUpCommands}
        '';
        serviceConfig.Type = "oneshot";
      };

      # Service executed before shutdown
      pre-shutdown = {
        description = "Pre-Shutdown Actions";
        wantedBy = [
          "shutdown.target"
        ];
        before = [
          "shutdown.target"
        ];
        script = cfg.powerDownCommands;
        serviceConfig.Type = "oneshot";
        unitConfig.DefaultDependencies = false;
      };

      # Service executed after boot
      post-boot = {
        description = "Post-Boot Actions";
        # It's not well defined at what point in the bootup sequence this should run
        # we should eventually just remove this.
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
        script = ''
          ${cfg.bootCommands}
          ${cfg.powerUpCommands}
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    };

  };

}
