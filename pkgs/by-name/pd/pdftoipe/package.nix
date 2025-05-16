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
  version = "7.2.29.1";

  src = fetchFromGitHub {
    owner = "otfried";
    repo = "ipe-tools";
    rev = "v${version}";
    hash = "sha256-6FI0ZLRrDmNFAKyht7hB94MsCy+TasD6Mb/rx6sdCdg=";
  };

  sourceRoot = "${src.name}/pdftoipe";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ poppler ];

  installPhase = ''
    install -D pdftoipe $out/bin/pdftoipe
  '';

  meta = with lib; {
    description = "Program that tries to convert arbitrary PDF documents to Ipe files";
    homepage = "https://github.com/otfried/ipe-tools";
    changelog = "https://github.com/otfried/ipe-tools/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yrd ];
    mainProgram = "pdftoipe";
  };
}
