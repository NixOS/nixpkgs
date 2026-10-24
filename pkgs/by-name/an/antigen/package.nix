{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.3.0";
  pname = "antigen";

  src = fetchurl {
    url = "https://github.com/zsh-users/antigen/releases/download/v${finalAttrs.version}/antigen.zsh";
    sha256 = "sha256-D04yaQ517Cg52s/C9jRHoqH+gHZ/JKEhD6MY/yrlA14=";
  };

  strictDeps = true;
  dontUnpack = true;

  installPhase = ''
    outdir=$out/share/antigen
    mkdir -p $outdir
    cp $src $outdir/antigen.zsh
  '';

  meta = {
    description = "Plugin manager for zsh";
    homepage = "https://antigen.sharats.me/";
    license = lib.licenses.mit;
  };
})
