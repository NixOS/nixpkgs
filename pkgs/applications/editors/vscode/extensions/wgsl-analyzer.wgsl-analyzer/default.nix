{
  lib,
  vscode-utils,
  jq,
  moreutils,
  wgsl-analyzer,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "wgsl-analyzer";
    publisher = "wgsl-analyzer";
    version = "0.11.539";
    hash = "sha256-0vS5UdARPbfwaTBg5M020/0OICm64x36U3lOqMvIjiU=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postPatch = ''
    jq '(.contributes.configuration[] | select(.title == "server") | .properties."wgsl-analyzer.server.path".default) = $s' \
      --arg s "${lib.getExe wgsl-analyzer}" \
      package.json | sponge package.json
  '';

  meta = {
    description = "Extension that integrates wgsl-analyzer a wgsl language server into VSCode";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=wgsl-analyzer.wgsl-analyzer";
    homepage = "https://github.com/wgsl-analyzer/wgsl-analyzer";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ timon ];
  };
}
