{ stdenv, ghcWithPackages, xmessage, makeWrapper, packages ? (x: []) }:

let
taffybarEnv = ghcWithPackages (self: [ self.taffybar ] ++ packages self);
in stdenv.mkDerivation {
  name = "taffybar-with-packages";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${taffybarEnv}/bin/taffybar $out/bin/taffybar \
      --set NIX_GHC "${taffybarEnv}/bin/ghc"
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
