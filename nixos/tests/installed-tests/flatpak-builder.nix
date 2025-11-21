{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.flatpak-builder;

  testConfig = {
    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      config.common.default = "gtk";
    };
    environment.systemPackages =
      with pkgs;
      [ flatpak-builder ] ++ flatpak-builder.installedTestsDependencies;
    virtualisation.diskSize = 2048;
  };

  testRunnerFlags = [
    "--timeout"
    "3600"
  ];
}
