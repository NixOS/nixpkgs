# run installed tests
import ./make-test.nix ({ pkgs, ... }: {
  name = "gjs";

  meta = {
    maintainers = pkgs.gnome3.gjs.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
    environment.variables.XDG_DATA_DIRS = [ "${pkgs.gnome3.gjs.installedTests}/share" ];
  };

  testScript = ''
    $machine->waitForX;
    $machine->succeed("gnome-desktop-testing-runner");
  '';
})
