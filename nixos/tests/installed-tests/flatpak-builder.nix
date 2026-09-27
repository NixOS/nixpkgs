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
    nix.enable = true; # disabled by default. See all-tests.nix / tag(no-nix-by-default)
  };

  testRunnerFlags = [
    "--timeout"
    "3600"
  ];
}
