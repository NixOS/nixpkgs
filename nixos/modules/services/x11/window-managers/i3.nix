{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.i3;
  updateSessionEnvironmentScript = ''
    systemctl --user import-environment PATH DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_RUNTIME_DIR XDG_SESSION_ID DBUS_SESSION_BUS_ADDRESS || true
    dbus-update-activation-environment --systemd --all || true
  '';
  defaultPackages = [
    dmenu
    i3status
  ];
in

{
  options.services.xserver.windowManager.i3 = {
    enable = mkEnableOption "i3 window manager";

    configFile = mkOption {
      default = null;
      type = with types; nullOr path;
      description = ''
        Path to the i3 configuration file.
        If left at the default value, $HOME/.i3/config will be used.
      '';
    };

    updateSessionEnvironment = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to run dbus-update-activation-environment and systemctl import-environment before session start.
        Required for xdg portals to function properly.
      '';
    };

    extraSessionCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands executed just before i3 is started.
      '';
    };

    package = mkPackageOption pkgs "i3" { };

    includeDefaultPackages = (mkEnableOption "extra default packages (dmenu, i3status, i3lock)") // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = [
      {
        name = "i3";
        start = ''
          ${cfg.extraSessionCommands}

          ${lib.optionalString cfg.updateSessionEnvironment updateSessionEnvironmentScript}

          ${cfg.package}/bin/i3 ${optionalString (cfg.configFile != null) "-c /etc/i3/config"} &
          waitPID=$!
        '';
      }
    ];
    environment.systemPackages = [
      cfg.package
    ] ++ optionals cfg.includeDefaultPackages defaultPackages;
    environment.etc."i3/config" = mkIf (cfg.configFile != null) {
      source = cfg.configFile;
    };
    programs.i3lock.enable = mkDefault cfg.includeDefaultPackages;
  };

  imports = [
    (mkRemovedOptionModule [
      "services"
      "xserver"
      "windowManager"
      "i3-gaps"
      "enable"
    ] "i3-gaps was merged into i3. Use services.xserver.windowManager.i3.enable instead.")
    (mkRemovedOptionModule
      [
        "services"
        "xserver"
        "windowManager"
        "i3"
        "extraPackages"
      ]
      "Move any packages you configured here to environment.systemPackages and set services.x11.window-managers.i3.includeDefaultPackages to 'false' to disable the defaults. If you configured i3lock, use programs.i3lock.enable instead."
    )
  ];
}
