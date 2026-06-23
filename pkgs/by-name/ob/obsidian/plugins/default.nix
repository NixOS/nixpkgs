{
  lib,
  callPackage,
}:
let
  root = ./.;

  assertManifestId =
    name: pkg:
    lib.trivial.warnIf (!(pkg ? manifestId))
      "Plugin '${name}' is missing passthru.manifestId - plugins should define this to identify themselves"
      pkg;
in
lib.pipe root [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (name: pkg: assertManifestId name (callPackage (root + "/${name}") { })))
]
