# run installed tests
import ./make-test.nix ({ pkgs, ... }:

{
  name = "libxmlb";
  meta = {
    maintainers = pkgs.libxmlb.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner -d '${pkgs.libxmlb.installedTests}/share'");
  '';
})
