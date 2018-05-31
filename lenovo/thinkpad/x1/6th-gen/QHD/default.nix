# X1 6th generation with a QHD (2560x1440px) display
{
  imports = [
    ../.
  ];

  services.xserver.dpi = 210;
  fonts.fontconfig.dpi = 210;
}
