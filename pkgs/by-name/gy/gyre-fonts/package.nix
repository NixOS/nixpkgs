{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gyre-fonts";
  version = "2.501";

  src = fetchzip {
    url = "http://www.gust.org.pl/projects/e-foundry/tex-gyre/whole/tg${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }otf.zip";
    hash = "sha256-mRPI/rDsx1vDVItG7h29I7VNPYqgSPqChXS6/gVgfNc=";
  };

  installPhase = ''
    runHook preInstall

    install -D --mode=444 --target-directory=$out/share/fonts/opentype *.otf

    runHook postInstall
  '';

  meta = {
    description = "OpenType fonts from the Gyre project, suitable for use with (La)TeX";
    longDescription = ''
      The Gyre project started in 2006, and will
      eventually include enhanced releases of all 35 freely available
      PostScript fonts distributed with Ghostscript v4.00.  These are
      being converted to OpenType and extended with diacritical marks
      covering all modern European languages and then some
    '';
    homepage = "https://www.gust.org.pl/projects/e-foundry/tex-gyre/index_html#Readings";
    license = lib.licenses.lppl13c;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bergey ];
  };
})
