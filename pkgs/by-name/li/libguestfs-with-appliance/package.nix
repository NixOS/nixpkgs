{
  lib,
  libguestfs,
  libguestfs-appliance,
}:

# https://github.com/NixOS/nixpkgs/issues/280881
lib.warnIf (builtins.compareVersions libguestfs.version libguestfs-appliance.version > 0)
  "libguestfs has a higher version than libguestfs-appliance (${libguestfs.version} > ${libguestfs-appliance.version}), runtime errors may occur!"

  libguestfs.override
  { appliance = libguestfs-appliance; }
