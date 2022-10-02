{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:

{
  # Some of these tests don't work with systemd stage 1 yet. Uncomment
  # them when fixed.
  inherit (import ./installer.nix { inherit system config pkgs; systemdStage1 = true; })
    # bcache
    # btrfsSimple
    # btrfsSubvolDefault
    # btrfsSubvols
    # encryptedFSWithKeyfile
    # grub1
    # luksroot
    # luksroot-format1
    # luksroot-format2
    # lvm
    separateBoot
    separateBootFat
    simple
    simpleLabels
    simpleProvided
    simpleSpecialised
    simpleUefiGrub
    simpleUefiGrubSpecialisation
    simpleUefiSystemdBoot
    # swraid
    zfsroot
    ;

}
