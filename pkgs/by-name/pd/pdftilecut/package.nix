{
  lib,
  buildGoModule,
  fetchFromGitHub,
  qpdf,
  libjpeg,
  libz,
}:

buildGoModule (finalAttrs: {
  pname = "pdftilecut";
  version = "0.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oxplot";
    repo = "pdftilecut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qKcwGLoKyBJ0Fej2rjlwpHb2bpFfMNiCsgINV7uufEA=";
  };

  buildInputs = [
    qpdf
    libjpeg
    libz
  ];

  vendorHash = "sha256-HX6OFmVPAIDhzXyAT/rk8OdsR10fDx6ellkMfvKrsT4=";

  meta = {
    description = "Sub-divide a PDF page(s) into smaller pages to print them on small form printers";
    homepage = "https://github.com/oxplot/pdftilecut";
    license = "lib.licenses.bsd3";
    maintainers = with lib.maintainers; [ hzeller ];
    mainProgram = "pdftilecut";
  };
})
