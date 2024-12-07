{ callPackage
, timeshift-unwrapped
, rsync
, coreutils
, mount
, umount
, psmisc
, cron
, btrfs-progs
, grubPackage
}:
let
  timeshift-wrapper = callPackage ./wrapper.nix { };
in
(timeshift-wrapper timeshift-unwrapped ([
  rsync
  coreutils
  mount
  umount
  psmisc
  cron
  btrfs-progs
  grubPackage
])).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    description = oldAttrs.meta.description;
    longDescription = oldAttrs.meta.longDescription + ''
      This package comes with runtime dependencies of command utilities provided by rsync, coreutils, mount, umount, psmisc, cron and btrfs.
      If you want to use the commands provided by the system, use timeshift-minimal instead.
    '';
  };
})
