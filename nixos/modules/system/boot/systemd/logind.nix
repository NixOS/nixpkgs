{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.logind;

  logindHandlerType = types.enum [
    "ignore" "poweroff" "reboot" "halt" "kexec" "suspend"
    "hibernate" "hybrid-sleep" "suspend-then-hibernate" "lock"
  ];
in
{
  options = {
    services.logind.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "IdleAction=lock";
      description = lib.mdDoc ''
        Extra config options for systemd-logind. See
        [
        logind.conf(5)](https://www.freedesktop.org/software/systemd/man/logind.conf.html) for available options.
      '';
    };

    services.logind.killUserProcesses = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Specifies whether the processes of a user should be killed
        when the user logs out.  If true, the scope unit corresponding
        to the session and all processes inside that scope will be
        terminated.  If false, the scope is "abandoned" (see
        [systemd.scope(5)](https://www.freedesktop.org/software/systemd/man/systemd.scope.html#)), and processes are not killed.

        See [logind.conf(5)](https://www.freedesktop.org/software/systemd/man/logind.conf.html#KillUserProcesses=)
        for more details.
      '';
    };

    services.logind.lidSwitch = mkOption {
      default = "suspend";
      example = "ignore";
      type = logindHandlerType;

      description = lib.mdDoc ''
        Specifies what to be done when the laptop lid is closed.
      '';
    };

    services.logind.lidSwitchDocked = mkOption {
      default = "ignore";
      example = "suspend";
      type = logindHandlerType;

      description = lib.mdDoc ''
        Specifies what to be done when the laptop lid is closed
        and another screen is added.
      '';
    };

    services.logind.lidSwitchExternalPower = mkOption {
      default = cfg.lidSwitch;
      defaultText = literalExpression "services.logind.lidSwitch";
      example = "ignore";
      type = logindHandlerType;

      description = lib.mdDoc ''
        Specifies what to do when the laptop lid is closed and the system is
        on external power. By default use the same action as specified in
        services.logind.lidSwitch.
      '';
    };
  };

  config = {
    systemd.additionalUpstreamSystemUnits = [
      "systemd-logind.service"
      "autovt@.service"
      "systemd-user-sessions.service"
    ] ++ optionals config.systemd.package.withImportd [
      "dbus-org.freedesktop.import1.service"
    ] ++ optionals config.systemd.package.withMachined [
      "dbus-org.freedesktop.machine1.service"
    ] ++ optionals config.systemd.package.withPortabled [
      "dbus-org.freedesktop.portable1.service"
    ] ++ [
      "dbus-org.freedesktop.login1.service"
      "user@.service"
      "user-runtime-dir@.service"
    ];

    environment.etc = {
      "systemd/logind.conf".text = ''
        [Login]
        KillUserProcesses=${if cfg.killUserProcesses then "yes" else "no"}
        HandleLidSwitch=${cfg.lidSwitch}
        HandleLidSwitchDocked=${cfg.lidSwitchDocked}
        HandleLidSwitchExternalPower=${cfg.lidSwitchExternalPower}
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
