{
  lib,
  vscode-utils,
  jaq,
  moreutils,
  oxlint,
  oxfmt,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "oxc";
    name = "oxc-vscode";
    version = "1.57.0";
    hash = "sha256-kz4YqPcDjBX7hT3O7odPQgYmGMO34VGw16d6mpzXq7c=";
  };

  nativeBuildInputs = [
    jaq
    moreutils
  ];

  postPatch = ''
    jaq \
      --arg oxlint "${lib.getExe oxlint}" \
      --arg oxfmt "${lib.getExe oxfmt}" \
      '
        .contributes.configuration.properties."oxc.path.oxlint".default = $oxlint |
        .contributes.configuration.properties."oxc.path.oxfmt".default = $oxfmt
      ' package.json | sponge package.json
  '';

  meta = {
    description = "Oxlint and Oxfmt editor integration";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=oxc.oxc-vscode";
    homepage = "https://github.com/oxc-project/oxc-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.drupol ];
  };
}
