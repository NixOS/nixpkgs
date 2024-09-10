{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "geist-font";
  version = "1.1.0";

  srcs = [
    (fetchzip {
      name = "geist-mono";
      url = "https://github.com/vercel/geist-font/releases/download/${version}/Geist.Mono.zip";
      stripRoot = false;
      hash = "sha256-8I4O2+bJAlUiDIhbyXzAcwXP5qpmHoh4IfrFio7IZN8=";
    })
    (fetchzip {
      name = "geist-sans";
      url = "https://github.com/vercel/geist-font/releases/download/${version}/Geist.zip";
      stripRoot = false;
      hash = "sha256-nSN+Ql5hTd230w/u6VZyAZaPtFSaHGmMc6T1fgGTCME=";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm444 geist-{mono,sans}/*/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    description = "Font family created by Vercel in collaboration with Basement Studio";
    homepage = "https://vercel.com/font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ x0ba ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
