{
  asciidoctor,
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "asciidoctor-vscode";
    publisher = "asciidoctor";
    version = "2.8.9";
    sha256 = "1xkxx5i3nhd0dzqhhdmx0li5jifsgfhv0p5h7xwsscz3gzgsdcyb";
  };

  postPatch = ''
    substituteInPlace dist/src/text-parser.js \
      --replace "get('asciidoctor_command', 'asciidoctor')" \
                "get('asciidoctor_command', '${asciidoctor}/bin/asciidoctor')"
    substituteInPlace dist/src/commands/exportAsPDF.js \
      --replace "get('asciidoctorpdf_command', 'asciidoctor-pdf')" \
                "get('asciidoctorpdf_command', '${asciidoctor}/bin/asciidoctor-pdf')"
  '';

  meta = {
    license = lib.licenses.mit;
  };
}
