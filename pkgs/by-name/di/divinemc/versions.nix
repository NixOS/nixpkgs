{
  lib,
  callPackage,
}:

let
  data = lib.importJSON ./versions.json;

  escapeVersion = builtins.replaceStrings [ "." ] [ "_" ];
in
lib.recurseIntoAttrs (
  lib.mapAttrs' (version: meta: {
    name = "divinemc-${escapeVersion version}";
    value = callPackage ./generic.nix ({ inherit version; } // meta);
  }) data.versions
)
