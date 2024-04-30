{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "geist-font";
  version = "1.3.0";

  srcs = [
    (fetchzip {
      name = "geist-mono";
      url = "https://github.com/vercel/geist-font/releases/download/${version}/GeistMono-${version}.zip";
      stripRoot = false;
      hash = "sha256-w3gMtYt5pGrPco19yH4Z6Uo0ntzRc6WqPW4RYa2E0Fw=";
    })
    (fetchzip {
      name = "geist-sans";
      url = "https://github.com/vercel/geist-font/releases/download/${version}/Geist-${version}.zip";
      stripRoot = false;
      hash = "sha256-DWLaVNKTzLWszy5fJUw7cOzSa27hilEucXV3snIk+0Q=";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm444 geist-{mono,sans}/*/*/*.otf -t $out/share/fonts/opentype
    install -Dm444 geist-{mono,sans}/*/*/*.ttf -t $out/share/fonts/truetype
    install -Dm444 geist-sans/Geist-${version}/LICENSE.TXT -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = {
    description = "Font family created by Vercel in collaboration with Basement Studio";
    homepage = "https://vercel.com/font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ eclairevoyant x0ba ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
