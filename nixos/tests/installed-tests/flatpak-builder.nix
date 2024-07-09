{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.flatpak-builder;

  testConfig = {
    services.flatpak.enable = true;
    xdg.portal.enable = true;
    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    environment.systemPackages = with pkgs; [ flatpak-builder ] ++ flatpak-builder.installedTestsDependencies;
    virtualisation.diskSize = 2048;
  };

  testRunnerFlags = [ "--timeout" "3600" ];
}
