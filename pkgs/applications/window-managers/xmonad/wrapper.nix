{ stdenv, ghcWithPackages, xmessage, makeWrapper, packages }:

let
xmonadEnv = ghcWithPackages (self: [ self.xmonad ] ++ packages self);
in stdenv.mkDerivation {
  name = "xmonad-with-packages";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin $out/share
    ln -s ${xmonadEnv}/share/man $out/share/man
    makeWrapper ${xmonadEnv}/bin/xmonad $out/bin/xmonad \
      --set NIX_GHC "${xmonadEnv}/bin/ghc" \
      --set XMONAD_XMESSAGE "${xmessage}/bin/xmessage"
  '';

  # trivial derivation
  preferLocalBuild = true;
  allowSubstitutes = false;
}
