# This module adds Memtest86 to the Grub boot menu on the CD.  !!! It
# would be nice if this also worked for normal configurations.

{config, pkgs, ...}:

let

  memtestPath = "/boot/memtest.bin";

  memtest86 = pkgs.memtest86;

in

{
  boot.loader.grub.extraEntries =
    ''
      menuentry "${memtest86.name}" {
        linux16 ${memtestPath}
      }
    '';

  isoImage.contents =
    [ { source = memtest86 + "/memtest.bin";
        target = memtestPath;
      }
    ];
}
