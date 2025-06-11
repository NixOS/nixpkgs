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
    version = "0.4.8";
    hash = "sha256-+U6AtT2wf1mE92IR+mv4aKD9/78ULus2GuwwgxdCvBA=";
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
