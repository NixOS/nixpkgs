# run installed tests
import ./make-test.nix ({ pkgs, ... }: {
  name = "gjs";

  meta = {
    maintainers = pkgs.gjs.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
    environment.variables.XDG_DATA_DIRS = [ "${pkgs.gjs.installedTests}/share" ];
  };

  testScript = ''
    $machine->waitForX;
    $machine->succeed("gnome-desktop-testing-runner");
  '';
})
