{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  poppler,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "pdftoipe";
  version = "7.2.29.2";

  src = fetchFromGitHub {
    owner = "otfried";
    repo = "ipe-tools";
    rev = "v${version}";
    hash = "sha256-BLZKOq7/3QSuwR0yjrDiiIh9N93qk8ihbEPIQ2h+Ffc=";
  };

  sourceRoot = "${src.name}/pdftoipe";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ poppler ];

  installPhase = ''
    install -D pdftoipe $out/bin/pdftoipe
  '';

  meta = {
    description = "Program that tries to convert arbitrary PDF documents to Ipe files";
    homepage = "https://github.com/otfried/ipe-tools";
    changelog = "https://github.com/otfried/ipe-tools/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yrd ];
    mainProgram = "pdftoipe";
  };
}
