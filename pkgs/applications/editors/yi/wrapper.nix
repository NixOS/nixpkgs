# To use this for hacking of your Yi config file, drop into a shell
# with env attribute.
{
  lib,
  stdenv,
  makeWrapper,
  haskellPackages,
  extraPackages ? (s: [ ]),
}:
let
  yiEnv = haskellPackages.ghcWithPackages (self: [ self.yi ] ++ extraPackages self);
in
stdenv.mkDerivation {
  pname = "yi-custom";
  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${haskellPackages.yi}/bin/yi $out/bin/yi \
      --set NIX_GHC ${yiEnv}/bin/ghc
  '';

  # For hacking purposes
  passthru.env = yiEnv;

  inherit (haskellPackages.yi) meta version;
}
