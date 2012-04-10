# This module adds Memtest86 to the Grub boot menu on the CD.

{config, pkgs, ...}:

let

  memtestPath = "/boot/memtest.bin";

in

{
  boot.loader.grub.extraEntries =
    ''
      menuentry "Memtest86" {
        linux16 ${memtestPath}
      }
    '';

  isoImage.contents =
    [ { source = pkgs.memtest86 + "/memtest.bin";
        target = memtestPath;
      }
    ];
}
