{
  lib,
  vscode-utils,
  jq,
  moreutils,
  wgsl-analyzer,
  setDefaultServerPath ? true,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "wgsl-analyzer";
    publisher = "wgsl-analyzer";
    version = "0.10.178";
    hash = "sha256-ZYhvCZ/ww6GbFF5ythVSgI41dZsbC4Y77s6+KEeEkCY=";
  };

  nativeBuildInputs = lib.optional setDefaultServerPath [
    jq
    moreutils
  ];

  postPatch = lib.optionalString setDefaultServerPath ''
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
