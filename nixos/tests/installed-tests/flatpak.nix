{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.flatpak;
  withX11 = true;

  testConfig = {
    services.xserver.desktopManager.gnome3.enable = true; # TODO: figure out minimal environment where the tests work
    # common/x11.nix enables the auto display manager (lightdm)
    services.xserver.displayManager.gdm.enable = false;
    services.gnome3.core-utilities.enable = false;
    services.flatpak.enable = true;
    environment.systemPackages = with pkgs; [ gnupg ostree python2 ];
    virtualisation.memorySize = 2047;
    virtualisation.diskSize = 1024;
  };

  testRunnerFlags = "--timeout 3600";
}
