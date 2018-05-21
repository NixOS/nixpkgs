# run installed tests
import ./make-test.nix ({ pkgs, ... }: {
  name = "gdk-pixbuf";

  meta = {
    maintainers = pkgs.gdk_pixbuf.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
    environment.variables.XDG_DATA_DIRS = [ "${pkgs.gdk_pixbuf.installedTests}/share" ];

    virtualisation.memorySize = 4096; # Tests allocate a lot of memory trying to exploit a CVE
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner");
  '';
})
