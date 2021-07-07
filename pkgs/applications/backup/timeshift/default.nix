{ callPackage
, lib
, timeshift-wrapper ? (callPackage ./wrapper.nix { })
, rsync
, coreutils
, mount
, umount
, psmisc
, cron
, enableBtrfs ? true, btrfs-progs ? null
, enableGrub ? true , grubPackage ? grub2_full, grub2_full ? null
}:

assert enableBtrfs -> (btrfs-progs != null);
assert enableGrub -> (grubPackage != null);

(timeshift-wrapper ([
  rsync
  coreutils
  mount
  umount
  psmisc
  cron
] ++ (lib.lists.optional enableBtrfs btrfs-progs)
++ (lib.lists.optional enableGrub grubPackage)
)).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    description = oldAttrs.meta.description;
    longDescription = oldAttrs.meta.longDescription + ''
      This package comes with runtime dependencies of command utilities provided by rsync, coreutils, mount, umount, psmisc, cron and (optionally) btrfs.
      If you want to use the commands provided by the system, override the propagatedBuildInputs or use timeshift-minimal instead
    '';
  };
})
