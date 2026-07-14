{
  callPackage,
  btrfs-progs,
  coreutils,
  cron,
  debianutils,
  grubPackage,
  mount,
  psmisc,
  rsync,
  timeshift-unwrapped,
  umount,
}:
let
  timeshift-wrapper = callPackage ./wrapper.nix { };
in
(timeshift-wrapper timeshift-unwrapped [
  btrfs-progs
  coreutils
  cron
  debianutils
  grubPackage
  mount
  psmisc
  rsync
  umount
]).overrideAttrs
  (oldAttrs: {
    meta = oldAttrs.meta // {
      description = oldAttrs.meta.description;
      longDescription = oldAttrs.meta.longDescription + ''
        This package comes with runtime dependencies of command utilities provided by rsync, coreutils, mount, umount, psmisc, cron and btrfs.
        If you want to use the commands provided by the system, use timeshift-minimal instead.
      '';
    };
  })
