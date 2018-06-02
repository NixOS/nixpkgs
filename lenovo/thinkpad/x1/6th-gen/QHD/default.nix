# X1 6th generation with a QHD (2560x1440px) display
{ config, lib, ... }:

{
  imports = [
    ../.
  ];

  # Fix font sizes in X
  services.xserver.dpi = 210;
  fonts.fontconfig.dpi = 210;

  # Fix sizes of GTK/GNOME ui elements
  environment.variables = {
    GDK_SCALE = lib.mkDefault "2";
    GDK_DPI_SCALE= lib.mkDefault "0.5";
  };
}
