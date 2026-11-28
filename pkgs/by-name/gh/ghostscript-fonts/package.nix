{
  stdenvNoCC,
  fetchgit,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  name = "ghostscript-fonts";
  version = "1.0.0-${"src.rev:0:7"}";
  src = fetchgit {
    url = "git://git.ghostscript.com/urw-core35-fonts.git";
    rev = "91edd6ece36e84a1c6d63a1cf63a1a6d84bd443a";
    hash = "sha256-T4Pcp1sv+WVl9UVdyVm6kSangEFuWarJ8xJ0CC3GyT8=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 ${src}/*.ttf -t $out/share/fonts/truetype
    install -Dm644 ${src}/*.otf -t $out/share/fonts/opentype
    install -Dm644 ${src}/*.{afm,t1} -t $out/share/fonts/type1

    runHook postInstall
  '';

  meta = {
    description = "Ghostscript fonts";
    longDescription = ''
      This package provides the Ghostscript fonts, which are a set of free
      alternatives to the standard 35 PostScript fonts defined by Adobe. These
      fonts are widely used in desktop publishing, graphic design, and printing
      applications.
      This package includes TrueType, OpenType, and
      Type 1 font formats for the follwoing fonts: C059, D050000L, NimbusSansNarrow,
      NumbusMonoPS, NumbusRoman, NumbusSans, P052, StandardSymbolsPS, URWBookman,
      URWGothic, and Z003.
    '';
    homepage = "https://ghostscript.com";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ vaavaav ];
  };
}
