{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let

  e = pkgs.enlightenment;
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.enlightenment;
  GST_PLUGIN_PATH = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-bad
    pkgs.gst_all_1.gst-libav
  ];

in

{
  meta = {
    maintainers = teams.enlightenment.members;
  };

  imports = [
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "e19" "enable" ]
      [ "services" "xserver" "desktopManager" "enlightenment" "enable" ]
    )
  ];

  options = {

    services.xserver.desktopManager.enlightenment.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Enlightenment desktop environment.";
    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      enlightenment.econnman
      enlightenment.efl
      enlightenment.enlightenment
      enlightenment.ecrire
      enlightenment.ephoto
      enlightenment.rage
      enlightenment.terminology
      xorg.xcursorthemes
    ];

    environment.pathsToLink = [
      "/etc/enlightenment"
      "/share/enlightenment"
      "/share/elementary"
      "/share/locale"
    ];

    services.displayManager.sessionPackages = [ pkgs.enlightenment.enlightenment ];

    services.xserver.displayManager.sessionCommands = ''
      if test "$XDG_CURRENT_DESKTOP" = "Enlightenment"; then
        export GST_PLUGIN_PATH="${GST_PLUGIN_PATH}"

        # make available for D-BUS user services
        #export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}:${config.system.path}/share:${e.efl}/share

        # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
        ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update
      fi
    '';

    # Wrappers for programs installed by enlightenment that should be setuid
    security.wrappers = {
      enlightenment_ckpasswd = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.enlightenment.enlightenment}/lib/enlightenment/utils/enlightenment_ckpasswd";
      };
      enlightenment_sys = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.enlightenment.enlightenment}/lib/enlightenment/utils/enlightenment_sys";
      };
      enlightenment_system = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.enlightenment.enlightenment}/lib/enlightenment/utils/enlightenment_system";
      };
    };

    environment.etc."X11/xkb".source = xcfg.xkb.dir;

    fonts.packages = [ pkgs.dejavu_fonts ];

    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;
    services.libinput.enable = mkDefault true;

    services.dbus.packages = [ e.efl ];

    systemd.user.services.efreet = {
      enable = true;
      description = "org.enlightenment.Efreet";
      serviceConfig = {
        ExecStart = "${e.efl}/bin/efreetd";
        StandardOutput = "null";
      };
    };

    systemd.user.services.ethumb = {
      enable = true;
      description = "org.enlightenment.Ethumb";
      serviceConfig = {
        ExecStart = "${e.efl}/bin/ethumbd";
        StandardOutput = "null";
      };
    };

  };

}
