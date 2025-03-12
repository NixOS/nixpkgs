{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.logind;

  logindHandlerType = lib.types.enum [
    "ignore"
    "poweroff"
    "reboot"
    "halt"
    "kexec"
    "suspend"
    "hibernate"
    "hybrid-sleep"
    "suspend-then-hibernate"
    "lock"
  ];
in
{
  options.services.logind = {
    extraConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      example = "IdleAction=lock";
      description = ''
        Extra config options for systemd-logind.
        See {manpage}`logind.conf(5)`
        for available options.
      '';
    };

    killUserProcesses = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Specifies whether the processes of a user should be killed
        when the user logs out.  If true, the scope unit corresponding
        to the session and all processes inside that scope will be
        terminated.  If false, the scope is "abandoned"
        (see {manpage}`systemd.scope(5)`),
        and processes are not killed.

        See {manpage}`logind.conf(5)`
        for more details.
      '';
    };

    powerKey = lib.mkOption {
      default = "poweroff";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the power key is pressed.
      '';
    };

    powerKeyLongPress = lib.mkOption {
      default = "ignore";
      example = "reboot";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the power key is long-pressed.
      '';
    };

    rebootKey = lib.mkOption {
      default = "reboot";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the reboot key is pressed.
      '';
    };

    rebootKeyLongPress = lib.mkOption {
      default = "poweroff";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the reboot key is long-pressed.
      '';
    };

    suspendKey = lib.mkOption {
      default = "suspend";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the suspend key is pressed.
      '';
    };

    suspendKeyLongPress = lib.mkOption {
      default = "hibernate";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the suspend key is long-pressed.
      '';
    };

    hibernateKey = lib.mkOption {
      default = "hibernate";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the hibernate key is pressed.
      '';
    };

    hibernateKeyLongPress = lib.mkOption {
      default = "ignore";
      example = "suspend";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the hibernate key is long-pressed.
      '';
    };

    lidSwitch = lib.mkOption {
      default = "suspend";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the laptop lid is closed.
      '';
    };

    lidSwitchExternalPower = lib.mkOption {
      default = cfg.lidSwitch;
      defaultText = lib.literalExpression "services.logind.lidSwitch";
      example = "ignore";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the laptop lid is closed
        and the system is on external power. By default use
        the same action as specified in services.logind.lidSwitch.
      '';
    };

    lidSwitchDocked = lib.mkOption {
      default = "ignore";
      example = "suspend";
      type = logindHandlerType;

      description = ''
        Specifies what to do when the laptop lid is closed
        and another screen is added.
      '';
    };
  };

  config = {
    systemd.additionalUpstreamSystemUnits =
      [
        "systemd-logind.service"
        "autovt@.service"
        "systemd-user-sessions.service"
      ]
      ++ lib.optionals config.systemd.package.withImportd [
        "dbus-org.freedesktop.import1.service"
      ]
      ++ lib.optionals config.systemd.package.withMachined [
        "dbus-org.freedesktop.machine1.service"
      ]
      ++ lib.optionals config.systemd.package.withPortabled [
        "dbus-org.freedesktop.portable1.service"
      ]
      ++ [
        "dbus-org.freedesktop.login1.service"
        "user@.service"
        "user-runtime-dir@.service"
      ];

    environment.etc = {
      "systemd/logind.conf".text = ''
        [Login]
        KillUserProcesses=${if cfg.killUserProcesses then "yes" else "no"}
        HandlePowerKey=${cfg.powerKey}
        HandlePowerKeyLongPress=${cfg.powerKeyLongPress}
        HandleRebootKey=${cfg.rebootKey}
        HandleRebootKeyLongPress=${cfg.rebootKeyLongPress}
        HandleSuspendKey=${cfg.suspendKey}
        HandleSuspendKeyLongPress=${cfg.suspendKeyLongPress}
        HandleHibernateKey=${cfg.hibernateKey}
        HandleHibernateKeyLongPress=${cfg.hibernateKeyLongPress}
        HandleLidSwitch=${cfg.lidSwitch}
        HandleLidSwitchExternalPower=${cfg.lidSwitchExternalPower}
        HandleLidSwitchDocked=${cfg.lidSwitchDocked}
        ${cfg.extraConfig}
      '';
    };

    # Restarting systemd-logind breaks X11
    # - upstream commit: https://cgit.freedesktop.org/xorg/xserver/commit/?id=dc48bd653c7e101
    # - systemd announcement: https://github.com/systemd/systemd/blob/22043e4317ecd2bc7834b48a6d364de76bb26d91/NEWS#L103-L112
    # - this might be addressed in the future by xorg
    #systemd.services.systemd-logind.restartTriggers = [ config.environment.etc."systemd/logind.conf".source ];
    systemd.services.systemd-logind.restartIfChanged = false;
    systemd.services.systemd-logind.stopIfChanged = false;

    # The user-runtime-dir@ service is managed by systemd-logind we should not touch it or else we break the users' sessions.
    systemd.services."user-runtime-dir@".stopIfChanged = false;
    systemd.services."user-runtime-dir@".restartIfChanged = false;
  };
}
