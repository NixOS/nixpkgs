{ lib, callPackage }:
{
  package,
  versions,
  mkName ? lib.versions.majorMinor,
  mkPackage ? callPackage package,
}@args:
lib.recurseIntoAttrs (
  lib.mapAttrs' (
    version: pkgArgs:
    let
      name = pkgArgs.name or mkName version;
      pkg = mkPackage (builtins.removeAttrs [ "name" ] pkgArgs // { inherit version; });
    in
    lib.nameValuePair name pkg
  ) versions
)
