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

    systemd.services = {
      # Service executed before suspending/hibernating.
      sleep-actions = {
        description = "Sleep Actions";
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        unitConfig.StopWhenUnneeded = true;
        script = ''
          # NixOS pre-sleep script

          # config.powerManagement.powerDownCommands
          ${cfg.powerDownCommands}
        '';
        preStop = ''
          # NixOS pre-resume script

          # config.powerManagement.resumeCommands
          ${cfg.resumeCommands}

          # config.powerManagement.powerUpCommands
          ${cfg.powerUpCommands}
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      # Service executed after boot, and stopped during shutdown
      post-boot = {
        description = "Post-Boot Actions";
        # It's not well defined at what point in the bootup sequence this should run
        # we should eventually just remove this.
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
        script = ''
          # NixOS post-boot script

          # config.powerManagement.bootCommands
          ${cfg.bootCommands}

          # config.powerManagement.powerUpCommands
          ${cfg.powerUpCommands}
        '';
        preStop = ''
          # NixOS pre-shutdown script

          # config.powerManagement.powerDownCommands
          ${cfg.powerDownCommands}
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    };

  };

}
