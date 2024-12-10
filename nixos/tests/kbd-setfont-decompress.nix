import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "kbd-setfont-decompress";

    meta.maintainers = with lib.maintainers; [ oxalica ];

    nodes.machine = { ... }: { };

    testScript = ''
      machine.succeed("gzip -cd ${pkgs.terminus_font}/share/consolefonts/ter-v16b.psf.gz >font.psf")
      machine.succeed("gzip <font.psf >font.psf.gz")
      machine.succeed("bzip2 <font.psf >font.psf.bz2")
      machine.succeed("xz <font.psf >font.psf.xz")
      machine.succeed("zstd <font.psf >font.psf.zst")
      # setfont returns 0 even on error.
      assert machine.succeed("PATH= ${pkgs.kbd}/bin/setfont font.psf.gz  2>&1") == ""
      assert machine.succeed("PATH= ${pkgs.kbd}/bin/setfont font.psf.bz2 2>&1") == ""
      assert machine.succeed("PATH= ${pkgs.kbd}/bin/setfont font.psf.xz  2>&1") == ""
      assert machine.succeed("PATH= ${pkgs.kbd}/bin/setfont font.psf.zst 2>&1") == ""
    '';
  }
)
