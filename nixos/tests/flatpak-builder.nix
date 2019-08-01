# run installed tests
import ./make-test.nix ({ pkgs, ... }:

{
  name = "flatpak-builder";
  meta = {
    maintainers = pkgs.flatpak-builder.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    services.flatpak.enable = true;
    xdg.portal.enable = true;
    environment.systemPackages = with pkgs; [ gnome-desktop-testing flatpak-builder ] ++ flatpak-builder.installedTestsDependencies;
    virtualisation.diskSize = 2048;
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner -d '${pkgs.flatpak-builder.installedTests}/share' --timeout 3600");
  '';
})
