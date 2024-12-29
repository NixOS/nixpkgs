{ config, lib, pkgs, utils, ... }:

let
  cfg = config.services.desktopManager.cosmic;
in
{
  meta.maintainers = with lib.maintainers; [
    thefossguy
  ];

  options = {
    services.desktopManager.cosmic = {
      enable = lib.mkEnableOption "COSMIC desktop environment";

      unstable.protocols.enable = lib.mkEnableOption "Enable the [currently unstable] cosmic-protocols" // {
        default = false;
      };

      xwayland.enable = lib.mkEnableOption "Xwayland support for cosmic-comp" // {
        default = true;
      };
    };

    environment.cosmic.excludePackages = lib.mkOption {
      description = "List of COSMIC packages to exclude from the default environment";
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.cosmic-player ]";
    };
  };

  config = lib.mkIf cfg.enable {
    # Environment packages
    environment.pathsToLink = [
      "/share/backgrounds"
      "/share/cosmic"
    ];
    environment.systemPackages = utils.removePackagesByName (
      with pkgs;
      [
        adwaita-icon-theme
        alsa-utils
        cosmic-applets
        cosmic-applibrary
        cosmic-bg
        cosmic-comp
        cosmic-edit
        cosmic-files
        cosmic-greeter
        cosmic-icons
        cosmic-idle
        cosmic-launcher
        cosmic-notifications
        cosmic-osd
        cosmic-panel
        cosmic-player
        cosmic-randr
        cosmic-reader
        cosmic-screenshot
        cosmic-session
        cosmic-settings
        cosmic-settings-daemon
        cosmic-term
        cosmic-wallpapers
        cosmic-workspaces-epoch
        hicolor-icon-theme
        playerctl
        pop-icon-theme
        pop-launcher
        xdg-user-dirs
      ]
      ++ lib.optionals cfg.unstable.protocols.enable [
        cosmic-protocols
      ]
      ++ lib.optionals cfg.xwayland.enable [
        xwayland
      ]
      ++ lib.optionals config.services.flatpak.enable [
        cosmic-store
      ]
    ) config.environment.cosmic.excludePackages;

    xdg.portal = {
      enable = true;
      extraPortals = lib.mkBefore [ pkgs.xdg-desktop-portal-cosmic ];
      configPackages = lib.mkDefault ([ pkgs.xdg-desktop-portal-cosmic ]);
    };

    systemd.user.targets.cosmic-session = {
      wants = [ "xdg-desktop-autostart.target" ];
      before = [ "xdg-desktop-autostart.target" ];
    };

    # Required options for the COSMIC DE
    environment.sessionVariables.X11_BASE_RULES_XML = "${config.services.xserver.xkb.dir}/rules/base.xml";
    environment.sessionVariables.X11_EXTRA_RULES_XML = "${config.services.xserver.xkb.dir}/rules/base.extras.xml";
    fonts.packages = utils.removePackagesByName [ pkgs.fira ] config.environment.cosmic.excludePackages;
    hardware.graphics.enable = true;
    programs.dconf.packages = with pkgs; [ cosmic-session ];
    security.pam.services.cosmic-greeter = { };
    security.polkit.enable = true;
    security.rtkit.enable = true;
    services.accounts-daemon.enable = true;
    services.displayManager.sessionPackages = with pkgs; [ cosmic-session ];
    services.libinput.enable = true;
    services.upower.enable = true;
    systemd.packages = with pkgs; [ cosmic-session ];
    xdg.icons.enable = true;
    xdg.mime.enable = true;

    # Good to have options
    hardware.bluetooth.enable = lib.mkDefault true;
    networking.networkmanager.enable = lib.mkDefault true;
    programs.dconf.enable = lib.mkDefault true;
    services.acpid.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;
    services.gvfs.enable = lib.mkDefault true;
    services.pipewire.alsa.enable = lib.mkDefault true;
    services.pipewire.enable = lib.mkDefault true;
    services.pipewire.pulse.enable = lib.mkDefault true;
    services.power-profiles-daemon.enable = lib.mkDefault (!config.hardware.system76.power-daemon.enable);

    warnings =
      lib.optional
        (
          lib.elem pkgs.cosmic-files config.environment.cosmic.excludePackages
          && !(lib.elem pkgs.cosmic-session config.environment.cosmic.excludePackages)
        )
        ''
          The COSMIC session may fail to initialise with the `cosmic-files` package excluded via
          `config.environment.cosmic.excludePackages`.

          Please do one of the following:
            1. Remove `cosmic-files` from `config.environment.cosmic.excludePackages`.
            2. Add `cosmic-session` (in addition to `cosmic-files`) to
               `config.environment.cosmic.excludePackages` and ensure whatever session starter/manager you are
               using is appropriately set up.
        '';

    assertions = [
      {
        assertion = lib.elem "libcosmic-app-hook" (
          lib.map (
            drv: lib.optionalString (lib.isDerivation drv) (lib.getName drv)
          ) pkgs.cosmic-comp.nativeBuildInputs
        );
        message = ''
          It looks like the provided `pkgs` to the NixOS COSMIC module is not usable for a working COSMIC
          desktop environment.

          If you are erroneously passing in `pkgs` to `specialArgs` somewhere in your system configuration,
          this is is often unnecessary and has unintended consequences for all NixOS modules. Please either
          remove that in favor of configuring the NixOS `pkgs` instance via `nixpkgs.config` and
          `nixpkgs.overlays`.

          If you must instantiate your own `pkgs`, then please include the overlay from the NixOS COSMIC flake
          when instantiating `pkgs` and be aware that the `nixpkgs.config` and `nixpkgs.overlays` options will
          not function for any NixOS modules.

          Note that the COSMIC packages in Nixpkgs are still largely broken as of 2024-10-16 and will not be
          usable for having a fully functional COSMIC desktop environment. The overlay is therefore necessary.
        '';
      }
    ];
  };
}
