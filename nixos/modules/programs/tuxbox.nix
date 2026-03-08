{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.tuxbox;
  upstreamCompositorChecks = [
    pkgs.hyprland
    pkgs.niri
    pkgs.sway
    pkgs.glib
    pkgs.kdotool
    pkgs.xdotool
  ];
  kdeSystemPackages = [
    pkgs.kdePackages.kwin
    pkgs.kdePackages.plasma-desktop
  ];
  gnomeSystemPackages = [
    pkgs.gnome-shell
  ];
  x11SystemPackages = [
    pkgs.awesome
    pkgs.dwm
    pkgs.herbstluftwm
    pkgs.i3
    pkgs.icewm
    pkgs.kdePackages.kwin-x11
    pkgs.xfdesktop
    pkgs.haskellPackages.xmonad
    pkgs.xmonad-with-packages
  ];
  mapSwayPackage = (
    # `programs.sway` generates the final package that will be put into `environment.systemPackages`.
    # Therefore, it will be different to the package in nixpkgs and `lib.elem pkgs.sway config.environment.systemPackages` will fail.
    if (config.programs.sway.enable || lib.elem pkgs.sway config.environment.systemPackages) then
      [ pkgs.sway ]
    else
      [ ]
  );
  mapPackageForSystem = (
    toolPkg:
    (
      systemPkgs:
      if (lib.filter (pkg: lib.elem pkg systemPkgs) config.environment.systemPackages) != [ ] then
        [ toolPkg ]
      else
        [ ]
    )
  );
in
{
  options.programs.tuxbox = {
    enable = lib.mkEnableOption "TuxBox";
    package = lib.mkPackageOption pkgs "tuxbox" { };
    systemdPathPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = lib.lists.unique (
        (lib.filter (
          pkg:
          lib.elem pkg
            # Binaries checked by upstream for existence to enable profile switching
            upstreamCompositorChecks

        ) config.environment.systemPackages)
        # Handle unique sway case
        ++ mapSwayPackage
        # Gnome cases
        ++ mapPackageForSystem pkgs.glib gnomeSystemPackages
        # KDE Wayland cases
        ++ mapPackageForSystem pkgs.kdotool kdeSystemPackages
        # X11 cases
        ++ mapPackageForSystem pkgs.xdotool x11SystemPackages
      );
      defaultText = lib.literalExpression ''
          lib.lists.unique (
            (lib.filter (
              pkg:
              lib.elem pkg (
                # Binaries checked by upstream for existence to enable profile switching
                upstreamCompositorChecks
              )
            ) config.environment.systemPackages)
            # Handle unique sway case
            ++ mapSwayPackage
            # Gnome cases
            ++ mapPackageForSystem pkgs.glib gnomeSystemPackages
            # KDE Wayland cases
            ++ mapPackageForSystem pkgs.kdotool kdeSystemPackages
            # X11 cases
            ++ mapPackageForSystem pkgs.xdotool x11SystemPackages
        );
      '';
      description = "Packages to include in the tuxbox Systemd service path.";
      example = ''
        programs.tuxbox = {
          enable = true;
          user = [ "john" ];
          systemdPathPackages = [
            pkgs.sway
          ];
        };
      '';
    };
    users = lib.mkOption {
      description = "User to add to the input and dialout group for the driver. If no user is assigned, the program will not work.";
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = ''
        programs.tuxbox = {
          enable = true;
          # The user name can be retrieved with `whoami` or `id -un`.
          user = [ "john" ];
        };
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    warnings =
      if cfg.systemdPathPackages == [ ] then
        [
          "Your system is using a window manager / desktop environment for which TuxBox has no profile switching support!"
        ]
      else
        [ ];

    assertions = [
      {
        assertion = builtins.any (user: builtins.hasAttr user config.users.users) cfg.users;
        message = "User for TuxBox driver is not set!";
      }
    ];

    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ pkgs.tuxbox ];

    users.users = builtins.listToAttrs (
      builtins.map (username: {
        name = username;
        value = {
          extraGroups = [
            "input"
            "dialout"
          ];
        };
      }) cfg.users
    );

    systemd.user.services."tuxbox" = {
      enable = true;
      name = "tuxbox.service";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      path = cfg.systemdPathPackages;
      unitConfig = {
        Description = "TuxBox Driver for TourBox Devices";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/tuxbox";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [
      CompileTime
    ];
    doc = ./tuxbox.md;
  };
}
