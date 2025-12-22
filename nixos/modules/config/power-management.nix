{ config, lib, ... }:
let

  cfg = config.powerManagement;
  inherit (lib)
    literalExpression
    mkIf
    mkOption
    types
    ;

in

{

  ###### interface

  options = {

    powerManagement = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable power management.  This includes support
          for suspend-to-RAM and powersave features on laptops.
        '';
      };

      resumeCommands = mkOption {
        type = types.lines;
        default = "";
        example = literalExpression ''
          "''${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ 75%"
        '';
        description = "Commands executed after the system resumes from suspend-to-RAM.";
      };

      powerUpCommands = mkOption {
        type = types.lines;
        default = "";
        example = literalExpression ''
          "''${pkgs.powertop}/bin/powertop --auto-tune"
        '';
        description = ''
          Commands executed when the machine powers up.  That is,
          they're executed both when the system first boots and when
          it resumes from suspend or hibernation.
        '';
      };

      powerDownCommands = mkOption {
        type = types.lines;
        default = "";
        example = literalExpression ''
          "''${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda"
        '';
        description = ''
          Commands executed when the machine powers down.  That is,
          they're executed both when the system shuts down and when
          it goes to suspend or hibernation.
        '';
      };

      bootCommands = mkOption {
        type = types.lines;
        default = "";
        example = literalExpression ''
          "''${pkgs.networkmanager}/bin/nmcli radio wifi on"
        '';
        description = ''
          Commands executed only once after initial boot.
          These commands are executed after `powerUpCommands`.
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

    systemd.services = {
      # Service executed before suspending/hibernating.
      pre-sleep = {
        description = "Pre-Sleep Actions";
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        script = ''
          ${cfg.powerDownCommands}
        '';
        serviceConfig.Type = "oneshot";
      };

      post-resume = {
        description = "Post-Resume Actions";
        after = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
          "suspend-then-hibernate.target"
        ];
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
        script = ''
          ${cfg.powerDownCommands}
        '';
        serviceConfig.Type = "oneshot";
        unitConfig.DefaultDependencies = false;
      };

      # Service executed after boot
      post-boot = {
        description = "Post-Boot Actions";
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${cfg.powerUpCommands}
          ${cfg.bootCommands}
        '';
        serviceConfig.Type = "oneshot";
      };
    };

  };

}
