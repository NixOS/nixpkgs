{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.flatpak;
  withX11 = true;

  testConfig = {
    xdg.portal.enable = true;
    services.flatpak.enable = true;
    environment.systemPackages = with pkgs; [ gnupg ostree python3 ];
    virtualisation.memorySize = 2047;
    virtualisation.diskSize = 3072;
  };

  testRunnerFlags = "--timeout 3600";
}
