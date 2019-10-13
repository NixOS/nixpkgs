# run installed tests
import ./make-test.nix {} ({ pkgs, ... }:

{
  name = "colord";

  meta = {
    maintainers = pkgs.colord.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner -d '${pkgs.colord.installedTests}/share'");
  '';
})
