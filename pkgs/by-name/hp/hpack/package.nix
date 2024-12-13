{
  lib,
  haskell,
  haskellPackages,
}:
let
  hpack =
    if
      builtins.compareVersions haskellPackages.hpack.version haskellPackages.hpack_0_37_0.version < 0
    then
      haskellPackages.hpack_0_37_0
    else
      lib.warn "`hpack` is newer than `hpack_0_37_0`. Please remove the override in Nixpkgs: ${builtins.toPath ./package.nix}" haskellPackages.hpack;

in
haskell.lib.compose.justStaticExecutables hpack
