{
  lib,
  stdenv,
  fetchurl,
  motif,
  libxpm,
  libxt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nedit";
  version = "5.8";

  src = fetchurl {
    url = "mirror://sourceforge/nedit/nedit-source/nedit-${finalAttrs.version}-src.tar.gz";
    sha256 = "sha256-WFGqclLa2VIIRSkXNkAjJWLexKfEQCCfGW1T1KWoB00=";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [
    motif
    libxpm
    libxt
  ];

  # the linux config works fine on darwin too!
  buildFlags = lib.optional (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin) "linux";

  env.NIX_CFLAGS_COMPILE = "-DBUILD_UNTESTED_NEDIT -L${motif}/lib";

  installPhase = ''
    mkdir -p $out/bin
    cp -p source/nedit source/nc $out/bin
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/nedit";
    description = "Fast, compact Motif/X11 plain text editor";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.gpl2;
  };
})
