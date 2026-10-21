{
  lib,
  vala-language-server,
  vscode-utils,
  jq,
  moreutils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vala";
    publisher = "prince781";
    version = "1.1.0";
    hash = "sha256-LJJDKhwzbGznyiXeB8SYir3LOM7/quYhGae1m4X/s3M=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."vala.languageServerPath".default = "${lib.getExe vala-language-server}"' package.json | sponge package.json
  '';

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/prince781.vala/changelog";
    description = "Syntax highlighting and language support for the Vala / Genie languages";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=prince781.vala";
    homepage = "https://github.com/vala-lang/vala-vscode#readme";
    license = lib.licenses.mit;
  };
}
