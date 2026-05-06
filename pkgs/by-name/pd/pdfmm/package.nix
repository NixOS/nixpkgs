{
  coreutils,
  fetchFromGitHub,
  ghostscript,
  gnused,
  lib,
  locale,
  makeWrapper,
  stdenvNoCC,
  zenity,
}:

stdenvNoCC.mkDerivation {
  pname = "pdfmm";
  version = "0-unstable-2019-01-24";

  src = fetchFromGitHub {
    owner = "jpfleury";
    repo = "pdfmm";
    rev = "45ee7796659d23bb030bf06647f1af85e1d2b52d";
    hash = "sha256-TOISD/2g7MwnLrtpMnfr2Ln0IiwlJVNavWl4eh/uwN0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm 0755 pdfmm $out/bin/pdfmm

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/pdfmm \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          ghostscript
          gnused
          locale
          zenity
        ]
      }
  '';

  meta = {
    description = "Graphical assistant to reduce the size of a PDF file";
    homepage = "https://github.com/jpfleury/pdfmm";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "pdfmm";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
