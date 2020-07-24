{ pkgs, lib, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.ostree;

  # TODO: Wrap/patch the tests directly in the package
  testConfig = {
    environment.systemPackages = with pkgs; [
      (python3.withPackages (p: with p; [ pyyaml ]))
      gnupg
      ostree
    ];

    # for GJS tests
    environment.variables.GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" (with pkgs; [
      gtk3
      pango.out
      ostree
      gdk-pixbuf
      atk
    ]);
  };
}
