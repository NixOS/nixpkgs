{ lib, stdenv }:
{
  inherit (import ./build-kakoune-plugin.nix { inherit lib stdenv; })
    buildKakounePlugin
    buildKakounePluginFrom2Nix
    ;
}
