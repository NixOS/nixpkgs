# This module adds Memtest86 to the Grub boot menu on the CD.  !!! It
# would be nice if this also worked for normal configurations.

{config, pkgs, ...}:

let

  memtestPath = "/boot/memtest.bin";

in

{
  boot.extraGrubEntries =
    ''
      title Memtest86+
        kernel ${memtestPath}
    '';

  isoImage.contents =
    [ { source = pkgs.memtest86 + "/memtest.bin";
        target = memtestPath;
      }
    ];
}
