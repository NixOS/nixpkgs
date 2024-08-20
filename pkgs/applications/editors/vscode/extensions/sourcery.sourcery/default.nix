{
  lib,
  stdenv,
  vscode-utils,
  autoPatchelfHook,
  zlib,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "sourcery";
    publisher = "sourcery";
    version = "1.22.0";
    hash = "sha256-G2sBH7qfMcoPoR7uz3D0xhfIsmvHkJgNRjcy58y7QeI=";
  };

  postPatch = ''
    pushd sourcery_binaries/install
    rm -r win ${if stdenv.isLinux then "mac" else "linux"}
    popd
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
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
