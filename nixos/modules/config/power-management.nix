{ config, lib, pkgs, ... }:

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
        description = ''
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
        example = literalExpression ''
          "''${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda"
        '';
        description = ''
            Commands executed when the machine powers up.  That is,
            they're executed both when the system first boots and when
            it resumes from suspend or hibernation.
            `$GOAL` contains either `suspend`, `hibernate`, `hybrid-sleep`, `suspend-then-hibernate` or `off`.
            `$SYSTEMD_SLEEP_ACTION` is identical to `$GOAL` except when `$GOAL` is `suspend-then-hibernate` where it refines it by either `suspend`, `hibernate`, or `suspend-after-failed-hibernate`.
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
            `$GOAL` contains either `suspend`, `hibernate`, `hybrid-sleep`, `suspend-then-hibernate` or `off`.
            `$SYSTEMD_SLEEP_ACTION` is identical to `$GOAL` except when `$GOAL` is `suspend-then-hibernate` where it refines it by either `suspend`, `hibernate`, or `suspend-after-failed-hibernate`.
          '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    # this file will be executed by system-sleep.service
    environment.etc."systemd/system-sleep/nixos-sleep.sh".source = pkgs.writeShellScript "nixos-sleep.sh" ''
      set +e
      export GOAL="$2"
      if [[ "$2" = "off" ]]; then
        export SYSTEMD_SLEEP_ACTION=off
      fi
      case "$1" in
        pre)
          ${cfg.powerDownCommands}
          ;;
        post)
          ${cfg.powerUpCommands}
          case "$SYSTEMD_SLEEP_ACTION" in
            suspend|suspend-after-failed-hibernate)
              ${cfg.resumeCommands}
              ;;
            *)
          esac
          ;;
        *)
          echo "/etc/systemd/system-sleep/nixos-sleep.sh called with unexpected argument $@"
        esac
    '';
    # system-suspend.service and co do not handle bootup and poweroff
    systemd.services.bootup-commands = {
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = [ "/etc/systemd/system-sleep/nixos-sleep.sh post off" ];
        Type = "oneshot";
      };
    };
    systemd.services.poweroff-commands = rec {
      before = wantedBy;
      wantedBy = [ "halt.target" "poweroff.target" "reboot.target" ];
      serviceConfig = {
        ExecStart = [ "/etc/systemd/system-sleep/nixos-sleep.sh pre off" ];
        Type = "oneshot";
      };
    };
  };
}
