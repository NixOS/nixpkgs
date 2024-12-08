{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.flatpak;
  withX11 = true;

  testConfig = {
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdg.portal.config.common.default = "gtk";
    services.flatpak.enable = true;
    environment.systemPackages = with pkgs; [ gnupg ostree python3 ];
    virtualisation.memorySize = 2047;
    virtualisation.diskSize = 3072;
  };

  testRunnerFlags = [ "--timeout" "3600" ];
}
