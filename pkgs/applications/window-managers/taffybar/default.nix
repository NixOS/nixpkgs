{ lib, stdenv, haskellPackages, makeWrapper, packages ? (x: []) }:

let
  taffybarEnv = haskellPackages.ghc.withPackages (self: [
    self.taffybar
  ] ++ packages self);
in stdenv.mkDerivation {
  name = "taffybar-with-packages-${taffybarEnv.version}";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${taffybarEnv}/bin/taffybar $out/bin/taffybar \
      --set NIX_GHC "${taffybarEnv}/bin/ghc"
  '';

  inherit (haskellPackages.taffybar) meta;
}
