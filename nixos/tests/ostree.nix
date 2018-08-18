# run installed tests
import ./make-test.nix ({ pkgs, lib, ... }: {
  name = "ostree";

  meta = {
    maintainers = pkgs.ostree.meta.maintainers;
  };

  # TODO: Wrap/patch the tests directly in the package
  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      gnome-desktop-testing ostree gnupg (python3.withPackages (p: with p; [ pyyaml ]))
    ];

    environment.variables.GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" (with pkgs; [ gtk3 pango.out ostree gdk_pixbuf atk ]); # for GJS tests
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner -d ${pkgs.ostree.installedTests}/share");
  '';
})
