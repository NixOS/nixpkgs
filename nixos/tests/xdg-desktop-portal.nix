# run installed tests
import ./make-test.nix ({ pkgs, ... }:

{
  name = "xdg-desktop-portal";
  meta = {
    maintainers = pkgs.xdg-desktop-portal.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner -d '${pkgs.xdg-desktop-portal.installedTests}/share'");
  '';
})
