{ lib, stdenv, ghcWithPackages, taffybar, makeWrapper, packages ? (x: []) }:

let
  taffybarEnv = ghcWithPackages (self: [
    self.taffybar
  ] ++ packages self);
in stdenv.mkDerivation {
  pname = "taffybar-with-packages";
  inherit (taffybar) version;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${taffybarEnv}/bin/taffybar $out/bin/taffybar \
      --set NIX_GHC "${taffybarEnv}/bin/ghc"
  '';

  # Trivial derivation
  preferLocalBuild = true;
  allowSubstitutes = false;

  # For hacking purposes
  passthru.env = taffybarEnv;
  buildInputs = [ taffybarEnv ];
  shellHook = "eval $(egrep ^export ${taffybarEnv}/bin/ghc)";

  inherit (taffybar) meta;
}
