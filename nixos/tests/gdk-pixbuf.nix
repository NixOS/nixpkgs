# run installed tests
import ./make-test.nix ({ pkgs, ... }: {
  name = "gdk-pixbuf";

  meta = {
    maintainers = pkgs.gdk-pixbuf.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
    environment.variables.XDG_DATA_DIRS = [ "${pkgs.gdk-pixbuf.installedTests}/share" ];

    # Tests allocate a lot of memory trying to exploit a CVE
    # but qemu-system-i386 has a 2047M memory limit
    virtualisation.memorySize = if pkgs.stdenv.isi686 then 2047 else 4096;
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner -t 1800"); # increase timeout to 1800s
  '';
})
