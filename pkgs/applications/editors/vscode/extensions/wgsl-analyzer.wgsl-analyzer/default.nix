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
    version = "0.11.141";
    hash = "sha256-egd9B5mS5pqzDWVry3dEQKfnxT4zI0RdLMJ/x5n6Nek=";
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
