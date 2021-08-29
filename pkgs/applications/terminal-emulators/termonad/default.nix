{ stdenv, ghcWithPackages, makeWrapper, packages ? (pkgSet: []) }:

let
  termonadEnv = ghcWithPackages (self: [ self.termonad ] ++ packages self);
in stdenv.mkDerivation {
  name = "termonad-with-packages-${termonadEnv.version}";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin $out/share
    makeWrapper ${termonadEnv}/bin/termonad $out/bin/termonad \
      --set NIX_GHC "${termonadEnv}/bin/ghc"
  '';

  # trivial derivation
  preferLocalBuild = true;
  allowSubstitutes = false;
}
