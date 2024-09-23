{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:

{
  # Some of these tests don't work with systemd stage 1 yet. Uncomment
  # them when fixed.
  inherit (import ./installer.nix { inherit system config pkgs; systemdStage1 = true; })
    # bcache
    bcachefsSimple
    bcachefsEncrypted
    btrfsSimple
    btrfsSubvolDefault
    btrfsSubvolEscape
    btrfsSubvols
    encryptedFSWithKeyfile
    # grub1
    luksroot
    luksroot-format1
    luksroot-format2
    lvm
    separateBoot
    separateBootFat
    separateBootZfs
    simple
    simpleLabels
    simpleProvided
    simpleSpecialised
    simpleUefiGrub
    simpleUefiGrubSpecialisation
    simpleUefiSystemdBoot
    stratisRoot
    swraid
    zfsroot
    clevisLuks
    clevisLuksFallback
    clevisZfs
    clevisZfsFallback
    clevisZfsParentDataset
    clevisZfsParentDatasetFallback
    gptAutoRoot
    clevisBcachefs
    clevisBcachefsFallback
    ;

}
