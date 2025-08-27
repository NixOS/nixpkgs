{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
{
  options.services.logind = {
    settings.Login = lib.mkOption {
      description = ''
        Settings option for systemd-logind.
        See {manpage}`logind.conf(5)` for available options.
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf utils.systemdUtils.unitOptions.unitOption;
        options.KillUserProcesses = lib.mkOption {
          default = false;
          type = lib.types.bool;
          description = ''
            Specifies whether the processes of a user should be killed
            when the user logs out.  If true, the scope unit corresponding
            to the session and all processes inside that scope will be
            terminated.  If false, the scope is "abandoned"
            (see {manpage}`systemd.scope(5)`),
            and processes are not killed.

            See {manpage}`logind.conf(5)` for more details.

            Defaulted to false in nixpkgs because many tools that rely on
            persistent user processes—like `tmux`, `screen`, `mosh`, `VNC`,
            `nohup`, and more — would break by the systemd-default behavior.
          '';
        };
      };
      default = { };
      example = {
        KillUserProcesses = false;
        HandleLidSwitch = "ignore";
      };
    };
  };

  config = {
    systemd.additionalUpstreamSystemUnits = [
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

    environment.etc."systemd/logind.conf".text = ''
      [Login]
      ${utils.systemdUtils.lib.attrsToSection config.services.logind.settings.Login}
    '';

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

  imports =
    let
      settingsRename =
        old: new:
        lib.mkRenamedOptionModule
          [ "services" "logind" old ]
          [ "services" "logind" "settings" "Login" new ];
    in
    [
      (lib.mkRemovedOptionModule [
        "services"
        "logind"
        "extraConfig"
      ] "Use services.logind.settings.Login instead.")

      (settingsRename "killUserProcesses" "KillUserProcesses")
      (settingsRename "powerKey" "HandlePowerKey")
      (settingsRename "powerKeyLongPress" "HandlePowerKeyLongPress")
      (settingsRename "rebootKey" "HandleRebootKey")
      (settingsRename "rebootKeyLongPress" "HandleRebootKeyLongPress")
      (settingsRename "suspendKey" "HandleSuspendKey")
      (settingsRename "suspendKeyLongPress" "HandleSuspendKeyLongPress")
      (settingsRename "hibernateKey" "HandleHibernateKey")
      (settingsRename "hibernateKeyLongPress" "HandleHibernateKeyLongPress")
      (settingsRename "lidSwitch" "HandleLidSwitch")
      (settingsRename "lidSwitchExternalPower" "HandleLidSwitchExternalPower")
      (settingsRename "lidSwitchDocked" "HandleLidSwitchDocked")
    ];
}
