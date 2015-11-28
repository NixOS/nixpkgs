{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.gtk;

  inherit (pkgs) stdenv lightdm writeScript writeText;

  theme = pkgs.gnome3.gnome_themes_standard;
  icons = pkgs.gnome3.defaultIconTheme;

  # The default greeter provided with this expression is the GTK greeter.
  # Again, we need a few things in the environment for the greeter to run with
  # fonts/icons.
  wrappedGtkGreeter = stdenv.mkDerivation {
    name = "lightdm-gtk-greeter";
    buildInputs = [ pkgs.makeWrapper ];

    buildCommand = ''
      # This wrapper ensures that we actually get themes
      makeWrapper ${pkgs.lightdm_gtk_greeter}/sbin/lightdm-gtk-greeter \
        $out/greeter \
        --prefix PATH : "${pkgs.glibc}/bin" \
        --set GDK_PIXBUF_MODULE_FILE "${pkgs.gdk_pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
        --set GTK_PATH "${theme}:${pkgs.gtk3}" \
        --set GTK_EXE_PREFIX "${theme}" \
        --set GTK_DATA_PREFIX "${theme}" \
        --set XDG_DATA_DIRS "${theme}/share:${icons}/share" \
        --set XDG_CONFIG_HOME "${theme}/share"

      cat - > $out/lightdm-gtk-greeter.desktop << EOF
      [Desktop Entry]
      Name=LightDM Greeter
      Comment=This runs the LightDM Greeter
      Exec=$out/greeter
      Type=Application
      EOF
    '';
  };

  gtkGreeterConf = writeText "lightdm-gtk-greeter.conf"
    ''
    [greeter]
    theme-name = Adwaita
    icon-theme-name = Adwaita
    background = ${ldmcfg.background}
    '';

in
{
  options = {
    services.xserver.displayManager.lightdm.greeters.gtk = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable lightdm-gtk-greeter as the lightdm greeter.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    services.xserver.displayManager.lightdm.greeter = mkDefault {
      package = wrappedGtkGreeter;
      name = "lightdm-gtk-greeter";
    };

    environment.etc."lightdm/lightdm-gtk-greeter.conf".source = gtkGreeterConf;

  };
}
