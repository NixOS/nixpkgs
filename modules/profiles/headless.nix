# Common configuration for headless machines (e.g., Amazon EC2
# instances).

{
  sound.enable = false;
  boot.vesa = false;
  boot.initrd.enableSplashScreen = false;
  services.ttyBackgrounds.enable = false;
  services.mingetty.ttys = [ ];
}
