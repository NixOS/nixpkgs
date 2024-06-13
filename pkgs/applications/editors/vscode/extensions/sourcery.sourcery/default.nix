{
  lib,
  stdenv,
  vscode-utils,
  autoPatchelfHook,
  libxcrypt-legacy,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "sourcery";
    publisher = "sourcery";
    version = "1.16.0";
    hash = "sha256-SHgS2C+ElTJW4v90Wg0QcsSL2FoSz+SxZQpgq2J4JiU=";
  };

  postPatch = ''
    pushd sourcery_binaries/install
    rm -r win ${if stdenv.isLinux then "mac" else "linux"}
    popd
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    libxcrypt-legacy
  ];

  meta = {
    changelog = "https://sourcery.ai/changelog/";
    description = "VSCode extension for Sourcery, an AI-powered code review and pair programming tool for Python";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=sourcery.sourcery";
    homepage = "https://github.com/sourcery-ai/sourcery-vscode";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
