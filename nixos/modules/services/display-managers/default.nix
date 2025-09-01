{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.displayManager;

  installedSessions =
    pkgs.runCommand "desktops"
      {
        # trivial derivation
        preferLocalBuild = true;
        allowSubstitutes = false;
      }
      ''
        mkdir -p "$out/share/"{xsessions,wayland-sessions}

        ${lib.concatMapStrings (pkg: ''
          for n in ${lib.concatStringsSep " " pkg.providedSessions}; do
            if ! test -f ${pkg}/share/wayland-sessions/$n.desktop -o \
                      -f ${pkg}/share/xsessions/$n.desktop; then
              echo "Couldn't find provided session name, $n.desktop, in session package ${pkg.name}:"
              echo "  ${pkg}"
              return 1
            fi
          done

          if test -d ${pkg}/share/xsessions; then
            ${pkgs.buildPackages.xorg.lndir}/bin/lndir ${pkg}/share/xsessions $out/share/xsessions
          fi
          if test -d ${pkg}/share/wayland-sessions; then
            ${pkgs.buildPackages.xorg.lndir}/bin/lndir ${pkg}/share/wayland-sessions $out/share/wayland-sessions
          fi
        '') cfg.sessionPackages}
      '';
in
{
  options = {
    services.displayManager = {
      enable = lib.mkEnableOption "systemd's display-manager service";

      preStart = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "rm -f /var/log/my-display-manager.log";
        description = "Script executed before the display manager is started.";
      };

      execCmd = lib.mkOption {
        type = lib.types.str;
        example = lib.literalExpression ''"''${pkgs.lightdm}/bin/lightdm"'';
        description = "Command to start the display manager.";
      };

      environment = lib.mkOption {
        type = with lib.types; attrsOf unspecified;
        default = { };
        description = "Additional environment variables needed by the display manager.";
      };

      hiddenUsers = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ "nobody" ];
        description = ''
          A list of users which will not be shown in the display manager.
        '';
      };

      logToFile = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether the display manager redirects the output of the
          session script to {file}`~/.xsession-errors`.
        '';
      };

      logToJournal = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether the display manager redirects the output of the
          session script to the systemd journal.
        '';
      };

      # Configuration for automatic login. Common for all DM.
      autoLogin = lib.mkOption {
        type = lib.types.submodule (
          { config, options, ... }:
          {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = config.user != null;
                defaultText = lib.literalExpression "config.${options.user} != null";
                description = ''
                  Automatically log in as {option}`autoLogin.user`.
                '';
              };

              user = lib.mkOption {
                type = with lib.types; nullOr str;
                default = null;
                description = ''
                  User to be used for the automatic login.
                '';
              };
            };
          }
        );

        default = { };
        description = ''
          Auto login configuration attrset.
        '';
      };

      defaultSession = lib.mkOption {
        type = lib.types.nullOr lib.types.str // {
          description = "session name";
          check =
            d:
            lib.assertMsg (d != null -> (lib.types.str.check d && lib.elem d cfg.sessionData.sessionNames)) ''
              Default graphical session, '${d}', not found.
              Valid names for 'services.displayManager.defaultSession' are:
                ${lib.concatStringsSep "\n  " cfg.sessionData.sessionNames}
            '';
        };
        default = null;
        example = "gnome";
        description = ''
          Graphical session to pre-select in the session chooser (only effective for GDM, LightDM and SDDM).

          On GDM, LightDM and SDDM, it will also be used as a session for auto-login.

          Set this option to empty string to get an error with a list of currently available sessions.
        '';
      };

      sessionData = lib.mkOption {
        description = "Data exported for display managers’ convenience";
        internal = true;
        default = { };
      };

      sessionPackages = lib.mkOption {
        type = lib.types.listOf (
          lib.types.package
          // {
            description = "package with provided sessions";
            check =
              p:
              lib.assertMsg
                (
                  lib.types.package.check p
                  && p ? providedSessions
                  && p.providedSessions != [ ]
                  && lib.all lib.isString p.providedSessions
                )
                ''
                  Package, '${p.name}', did not specify any session names, as strings, in
                  'passthru.providedSessions'. This is required when used as a session package.

                  The session names can be looked up in:
                    ${p}/share/xsessions
                    ${p}/share/wayland-sessions
                '';
          }
        );
        default = [ ];
        description = ''
          A list of packages containing x11 or wayland session files to be passed to the display manager.
        '';
      };
    };
  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "autoLogin" ]
      [ "services" "displayManager" "autoLogin" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "defaultSession" ]
      [ "services" "displayManager" "defaultSession" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "hiddenUsers" ]
      [ "services" "displayManager" "hiddenUsers" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "job" "environment" ]
      [ "services" "displayManager" "environment" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "job" "execCmd" ]
      [ "services" "displayManager" "execCmd" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "job" "logToFile" ]
      [ "services" "displayManager" "logToFile" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "job" "logToJournal" ]
      [ "services" "displayManager" "logToJournal" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "job" "preStart" ]
      [ "services" "displayManager" "preStart" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sessionData" ]
      [ "services" "displayManager" "sessionData" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "xserver" "displayManager" "sessionPackages" ]
      [ "services" "displayManager" "sessionPackages" ]
    )
  ];

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.autoLogin.enable -> cfg.autoLogin.user != null;
        message = ''
          services.displayManager.autoLogin.enable requires services.displayManager.autoLogin.user to be set
        '';
      }
    ];

    # Make xsessions and wayland sessions available in XDG_DATA_DIRS
    # as some programs have behavior that depends on them being present
    environment.sessionVariables.XDG_DATA_DIRS = lib.mkIf (cfg.sessionPackages != [ ]) [
      "${cfg.sessionData.desktops}/share"
    ];

    services.displayManager.sessionData = {
      desktops = installedSessions;
      sessionNames = lib.concatMap (p: p.providedSessions) cfg.sessionPackages;
      # We do not want to force users to set defaultSession when they have only single DE.
      autologinSession =
        if cfg.defaultSession != null then
          cfg.defaultSession
        else if cfg.sessionData.sessionNames != [ ] then
          lib.head cfg.sessionData.sessionNames
        else
          null;
    };

    # so that the service won't be enabled when only startx is used
    systemd.services.display-manager.enable =
      let
        dmConf = config.services.xserver.displayManager;
        noDmUsed =
          !(
            cfg.gdm.enable
            || cfg.sddm.enable
            || dmConf.xpra.enable
            || dmConf.lightdm.enable
            || cfg.ly.enable
            || cfg.lemurs.enable
          );
      in
      lib.mkIf noDmUsed (lib.mkDefault false);

    systemd.services.display-manager = {
      description = "Display Manager";
      after = [
        "acpid.service"
        "systemd-logind.service"
        "systemd-user-sessions.service"
        "autovt@tty1.service"
      ];
      conflicts = [
        "autovt@tty1.service"
      ];
      restartIfChanged = false;

      environment = cfg.environment;

      preStart = cfg.preStart;
      script = lib.mkIf (config.systemd.services.display-manager.enable == true) cfg.execCmd;

      # Stop restarting if the display manager stops (crashes) 2 times
      # in one minute. Starting X typically takes 3-4s.
      startLimitIntervalSec = 30;
      startLimitBurst = 3;
      serviceConfig = {
        Restart = "always";
        RestartSec = "200ms";
        SyslogIdentifier = "display-manager";
      };
    };
  };
}
