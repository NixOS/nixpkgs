{
  lib,
  vscode-utils,
  jq,
  moreutils,
  pandoc,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-pandoc";
    publisher = "chrischinchilla";
    version = "0.7.2";
    hash = "sha256-Vq9VayQVhlz97Ml0nfBCwlF41V+TqA46jHHW7TMJLeI=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    jq '.contributes.configuration.properties."pandoc.executable".default = "${lib.getExe pandoc}"' $out/$installPrefix/package.json | sponge $out/$installPrefix/package.json
  '';
  meta = {
    description = "Converts Markdown files to pdf, docx, or html files using pandoc";
    homepage = "https://github.com/ChrisChinchilla/vscode-pandoc#readme";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
