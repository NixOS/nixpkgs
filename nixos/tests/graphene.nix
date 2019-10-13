# run installed tests
import ./make-test.nix {} ({ pkgs, ... }:

{
  name = "graphene";

  meta = {
    maintainers = pkgs.graphene.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner -d '${pkgs.graphene.installedTests}/share'");
  '';
})
