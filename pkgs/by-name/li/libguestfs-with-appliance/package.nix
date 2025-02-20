{
  lib,
  libguestfs,
  libguestfs-appliance-debian,
}:

# https://github.com/NixOS/nixpkgs/issues/280881
lib.warnIf
  (
    builtins.compareVersions libguestfs.version libguestfs-appliance-debian.version != 0
    && libguestfs.version != "1.54.0" # FIXME(malte-v): remove this clause once libguestfs-appliance-debian is at v1.54.0
  )
  "libguestfs has a different version than libguestfs-appliance-debian (${libguestfs.version} != ${libguestfs-appliance-debian.version}), runtime errors may occur!"

  libguestfs.override
  { appliance = libguestfs-appliance-debian; }
