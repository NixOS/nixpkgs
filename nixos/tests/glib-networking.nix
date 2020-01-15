# run installed tests
import ./make-test.nix ({ pkgs, ... }:

{
  name = "glib-networking";
  meta = {
    maintainers = pkgs.glib-networking.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner -d '${pkgs.glib-networking.installedTests}/share'");
  '';
})
