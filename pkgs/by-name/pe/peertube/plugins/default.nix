{
  lib,
  callPackage,
  unstableGitUpdater,
}:
let
  root = ./.;
  call =
    name:
    (callPackage (root + "/${name}") { })
    // {
      passthru.updateScript = [
        ./update.sh
        (unstableGitUpdater { })
      ];
    };
in
lib.pipe root [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (name: _: call name))
]
