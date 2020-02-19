{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cage;
in {
  options.services.cage.enable = mkEnableOption ''
    Enable the Cage Kiosk service.
  '';

  options.services.cage.user = mkOption {
    type = types.str;
    default = "demo";
    description = ''
      User to log-in as.
    '';
  };

  options.services.cage.program = mkOption {
    type = types.path;
    default = "${pkgs.xterm}/bin/xterm";
    description = ''
      Program to run in cage.
    '';
  };

  config = mkIf cfg.enable {

    # The service is partially based off of the one provided in the
    # cage wiki at
    # https://github.com/Hjdskes/cage/wiki/Starting-Cage-on-boot-with-systemd.
    systemd.services."cage@" = {
      enable = true;
      after = [ "systemd-user-sessions.service" "plymouth-quit.service" "dbus.socket" "systemd-logind.service" "getty@%i.service" "plymouth-deactivate.service" ];
      before = [ "graphical.target" ];
      wants = [ "dbus.socket" "systemd-logind.service" "plymouth-deactivate.service" ];
      wantedBy = [ "graphical.target" ];
      conflicts = [ "getty@%i.service" "plymouth-quit.service" "plymouth-quit-wait.service" ];

      restartIfChanged = false;
      serviceConfig = {
        ExecStart = "${pkgs.cage}/bin/cage -d -- ${cfg.program}";
        User = cfg.user;

        # ConditionPathExists = "/dev/tty0";
        IgnoreSIGPIPE = "no";

        # Log this user with utmp, letting it show up with commands 'w' and
        # 'who'. This is needed since we replace (a)getty.
        UtmpIdentifier = "%I";
        UtmpMode = "user";
        # A virtual terminal is needed.
        TTYPath = "/dev/%I";
        TTYReset = "yes";
        TTYVHangup = "yes";
        TTYVTDisallocate = "yes";
        # Fail to start if not controlling the virtual terminal.
        StandardInput = "tty-fail";
        StandardOutput = "syslog";
        StandardError = "syslog";
        # Set up a full (custom) user session for the user, required by Cage.
        PAMName = "cage";
      };
    };

    security.pam.services.cage.text = ''
      auth    required pam_unix.so nullok
      account required pam_unix.so
      session required pam_unix.so
      session required ${pkgs.systemd}/lib/security/pam_systemd.so
    '';

    systemd.targets.graphical.wants = [ "cage@tty1.service" ];

    systemd.defaultUnit = "graphical.target";

  };

  meta.maintainers = with lib.maintainers; [ matthewbauer ];

}
