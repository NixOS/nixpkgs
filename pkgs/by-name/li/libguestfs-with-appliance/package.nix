{
  lib,
  libguestfs,
  libguestfs-appliance-fedora,
}:

let
  appliance = libguestfs-appliance-fedora;
  # check explicit forward compatibility declaration:
  # then do not warn if older appliance if known to work fine with newer libguestfs
  libguestfsCompatible =
    if lib.hasAttr "libguestfsCompatible" appliance then
      appliance.libguestfsCompatible libguestfs
    else
      false;
in
# https://github.com/NixOS/nixpkgs/issues/280881
lib.warnIf
  (
    builtins.compareVersions (lib.versions.majorMinor libguestfs.version) (
      lib.versions.majorMinor appliance.version
    ) > 0
    && !libguestfsCompatible
  )
  "libguestfs has a different version than ${appliance.pname} (${libguestfs.version} > ${appliance.version}), runtime errors may occur!"

  libguestfs.override
  { inherit appliance; }
