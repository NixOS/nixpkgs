{ stdenv, buildEnv, ghcWithPackages, xmessage, makeWrapper, packages }:

let
xmonadEnv = ghcWithPackages (self: [ self.xmonad ] ++ packages self);
drv = buildEnv {
  name = "xmonad-with-packages";

  paths = [ xmonadEnv ];

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    rm $out/bin
    mkdir $out/bin
    for i in ${xmonadEnv}/bin/*; do
      ln -s $i $out/bin
    done
    wrapProgram $out/bin/xmonad \
      --set XMONAD_GHC "${xmonadEnv}/bin/ghc" \
      --set XMONAD_XMESSAGE "${xmessage}/bin/xmessage"
  '';
  };
in stdenv.lib.overrideDerivation drv (x : { buildInputs = x.buildInputs ++ [ makeWrapper ]; })
