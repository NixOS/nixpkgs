{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    escapeShellArgs
    literalExpression
    maintainers
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.services.cage;
  tty = "tty${toString cfg.tty}";
in
{
  options.services.cage = {
    enable = mkEnableOption "cage kiosk service";

    user = mkOption {
      type = types.str;
      default = "demo";
      description = ''
        User to log-in as.
      '';
    };
    vt = mkOption {
      type = types.int;
      default = 1;
      description = ''
        The virtual console (tty) that cage should use. This option also disables getty on that tty.
      '';
    };

    extraArguments = mkOption {
      type = types.listOf types.str;
      default = [ ];
      defaultText = literalExpression "[]";
      description = "Additional command line arguments to pass to Cage.";
      example = [ "-d" ];
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        WLR_LIBINPUT_NO_DEVICES = "1";
      };
      description = "Additional environment variables to pass to Cage.";
    };

    program = mkOption {
      type = types.path;
      default = "${pkgs.xterm}/bin/xterm";
      defaultText = literalExpression ''"''${pkgs.xterm}/bin/xterm"'';
      description = ''
        Program to run in cage.
      '';
    };

    package = mkPackageOption pkgs "cage" { };
  };

  config = mkIf cfg.enable {

    # The service is partially based off of the one provided in the
    # cage wiki at
    # https://github.com/Hjdskes/cage/wiki/Starting-Cage-on-boot-with-systemd.
    systemd.services."cage-${tty}" = {
      enable = true;
      after = [
        "systemd-user-sessions.service"
        "plymouth-start.service"
        "plymouth-quit.service"
        "systemd-logind.service"
        "getty@${tty}.service"
      ];
      before = [ "graphical.target" ];
      wants = [
        "dbus.socket"
        "systemd-logind.service"
        "plymouth-quit.service"
      ];
      wantedBy = [ "graphical.target" ];
      conflicts = [ "getty@${tty}.service" ];

      restartIfChanged = false;
      unitConfig.ConditionPathExists = "/dev/${tty}";
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/cage \
            ${escapeShellArgs cfg.extraArguments} \
            -- ${cfg.program}
        '';
        User = cfg.user;

        IgnoreSIGPIPE = "no";

        # Log this user with utmp, letting it show up with commands 'w' and
        # 'who'. This is needed since we replace (a)getty.
        UtmpIdentifier = "%n";
        UtmpMode = "user";
        # A virtual terminal is needed.
        TTYPath = "/dev/${tty}";
        TTYReset = "yes";
        TTYVHangup = "yes";
        TTYVTDisallocate = "yes";
        # Fail to start if not controlling the virtual terminal.
        StandardInput = "tty-fail";
        StandardOutput = "journal";
        StandardError = "journal";
        # Set up a full (custom) user session for the user, required by Cage.
        PAMName = "cage";
      };
      environment = cfg.environment;
    };

    security.polkit.enable = true;

    security.pam.services.cage.text = ''
      auth    required pam_unix.so nullok
      account required pam_unix.so
      session required pam_unix.so
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required ${config.systemd.package}/lib/security/pam_systemd.so
    '';

    hardware.graphics.enable = mkDefault true;

    systemd.targets.graphical.wants = [ "cage-${tty}.service" ];

    systemd.defaultUnit = "graphical.target";

    # Prevent nixos-rebuild from killing cage by starting getty
    systemd.services."autovt@${tty}".enable = false;
  };

  meta.maintainers = with maintainers; [ matthewbauer ];

}
