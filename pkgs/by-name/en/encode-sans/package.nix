{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "encode-sans";
  version = "1.002";

  src = fetchzip {
    url = "https://github.com/impallari/Encode-Sans/archive/11162b46892d20f55bd42a00b48cbf06b5871f75.zip";
    hash = "sha256-TPAUc5msAUgJZHibjgYaS2TOuzKFy0rje9ZQTXE6s+w=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf                 -t $out/share/fonts/truetype
    install -Dm644 README.md FONTLOG.txt -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Versatile sans serif font family";
    longDescription = ''
      The Encode Sans family is a versatile workhorse. Featuring a huge range of
      weights and widths, it's ready for all kind of typographic challenges. It
      also includes Tabular and Old Style figures, as well as full set of Small
      Caps and other Open Type features.

      Designed by Pablo Impallari and Andres Torresi.
    '';
    homepage = "https://github.com/impallari/Encode-Sans";
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
