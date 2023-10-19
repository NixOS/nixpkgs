{ lib
, buildGoModule
, chromium
, fetchFromGitHub
, go
, libreoffice
, makeWrapper
, pdftk
, qpdf
, unoconv
}:

buildGoModule rec {
  pname = "gotenberg";
  version = "7.9.2";

  src = fetchFromGitHub {
    owner = "gotenberg";
    repo = "gotenberg";
    rev = "refs/tags/v${version}";
    hash = "sha256-WOmKuK9pcqGUpojakQfLIVbbEOtxiwjySz8iUbj2k9g=";
  };

  vendorHash = "sha256-zdpeCdk1BD1vdc8c48xf5z7u8S7gaT6AWTC5ArgfpBk=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gotenberg/gotenberg/v7/cmd.Version=${version}"
  ];

  preFixup = ''
    wrapProgram $out/bin/gotenberg \
      --set CHROMIUM_BIN_PATH "${chromium}/bin/chromium" \
      --set LIBREOFFICE_BIN_PATH "${libreoffice}/lib/libreoffice/program/soffice.bin" \
      --set PDFTK_BIN_PATH "${pdftk}/bin/pdftk" \
      --set QPDF_BIN_PATH "${qpdf}/bin/qpdf" \
      --set UNOCONV_BIN_PATH "${unoconv}/bin/unoconv"
  '';

  meta = with lib; {
    description = "Converts numerous document formats into PDF files";
    homepage = "https://github.com/gotenberg/gotenberg";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}

