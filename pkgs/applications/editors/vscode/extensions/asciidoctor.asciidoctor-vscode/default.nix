{
  asciidoctor,
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "asciidoctor-vscode";
    publisher = "asciidoctor";
    version = "3.4.2";
    hash = "sha256-HG3y7999xeE1erQZCnBgUPj/aC0Kwyn20PEZR9gKrxY=";
  };

  patches = [
    ./commands-abspath.patch
  ];

  postPatch = ''
    substituteInPlace package.json \
        --replace-fail "@ASCIIDOCTOR_PDF_BIN@" \
                       "${asciidoctor}/bin/asciidoctor-pdf"
  '';

  meta = {
    license = lib.licenses.mit;
  };
}
