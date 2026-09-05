{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.displayManager.phrog;

  iniFormat = pkgs.formats.ini { };

  phocConfig = iniFormat.generate "phoc.ini" cfg.phocConfig;

  # Ensure we have keyboard available during login
  greeterShell = pkgs.writeShellScript "phrog-shell" ''
    ${lib.optionalString cfg.osk.enable ''
      ${lib.getExe' cfg.osk.package "squeekboard"} &
    ''}
    exec ${lib.getExe cfg.package}
  '';

  greetdSession = pkgs.writeShellScript "phrog-greetd-session" ''
    export XDG_CURRENT_DESKTOP=Phrog:Phosh:GNOME

    # get sessions
    export XDG_DATA_DIRS=${config.services.displayManager.sessionData.desktops}/share:/run/current-system/sw/share

    # greetd swallows its greeter's stdio; keep the logs.
    exec > >(${config.systemd.package}/bin/systemd-cat --identifier=phrog) 2>&1

    # phoc needs a session bus to initialise at all.
    exec ${pkgs.dbus}/bin/dbus-run-session -- \
      ${lib.getExe cfg.phocPackage} -S -C ${phocConfig} -E ${greeterShell}
  '';
in
{
  options.services.displayManager.phrog = {
    enable = lib.mkEnableOption ''
      phrog, a touch-friendly greetd greeter built on Phosh. Configures greetd
      to run it under phoc, replacing the display manager
    '';

    package = lib.mkPackageOption pkgs "phoc" { } // {
      description = "The phrog package to use.";
    };

    phocPackage = lib.mkPackageOption pkgs "phoc" { } // {
      description = "The phoc compositor the greeter runs under.";
    };

    osk = {
      enable =
        lib.mkEnableOption ''
          Start an on-screen keyboard next to the greeter. Without it there is
          no way to type a password on a device with no hardware keyboard.
        ''
        // {
          default = true;
        };

      package = lib.mkPackageOption pkgs "squeekboard" { } // {
        description = "Package providing the `squeekboard` OSK binary.";
      };
    };

    phocConfig = lib.mkOption {
      type = lib.types.submodule {
        freeformType = iniFormat.type;
      };
      default = {
        core.xwayland = false;
        "output:DSI-1".scale = 3;
      };
      description = ''
        Config rendered to the `phoic.ini` the greeter's compositor is started with.
        The default sets suitable scale for a phone and assumes output is DSI-1
      '';
    };

    home = lib.mkOption {
      type = lib.types.path;
      default = "/run/phrog";
      description = ''
        Home directory for greetd's `greeter` user. phrog persists its
        `last-user` and `last-session` settings through dconf, which needs a
        writable home; the default `greeter` account has none.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${greetdSession}";
    };

    # phrog's user list comes from org.freedesktop.Accounts
    services.accounts-daemon.enable = true;

    users.users.greeter.home = cfg.home;

    systemd.tmpfiles.settings."10-phrog".${cfg.home}.d = {
      user = "greeter";
      group = "greeter";
      mode = "0700";
    };

    environment.systemPackages = [
      cfg.package
      cfg.phocPackage
    ]
    ++ lib.optional cfg.osk.enable cfg.osk.package;
  };
  meta.maintainers = with lib.maintainers; [
    marcusramberg
  ];
}
