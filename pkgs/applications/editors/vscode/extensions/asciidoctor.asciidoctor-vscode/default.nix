{
  asciidoctor,
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "asciidoctor-vscode";
    publisher = "asciidoctor";
    version = "3.4.5";
    hash = "sha256-X7njFSqfb45l6ZTr7GDS3At6DMHyvBT41JoghOeVjwI=";
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
