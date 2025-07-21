{
  lib,
  vscode-utils,

  autoPatchelfHook,
  libxkbcommon,
  fontconfig,
  freetype,
  libinput,
  libgbm,
  libgcc,
  stdenv,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "slint";
    publisher = "Slint";
    version = "1.12.1";
    sha256 = "LqnJQIjiN/KVL40RD21mGUpC7TbVdLmG/u4pKRVlHzs=";
  };
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook

    stdenv.cc.cc.lib
    libxkbcommon
    fontconfig
    freetype
    libinput
    libgbm
    libgcc
  ];
  meta = {
    changelog = "https://github.com/slint-ui/slint/blob/master/CHANGELOG.md";
    description = "Visual Studio Code extension for the Slint language, featuring auto-completion, go-to definition, refactoring, syntax coloration, and a live preview and editing of Slint GUIs";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Slint.slint";
    homepage = "https://github.com/slint-ui/slint/tree/master/editors/vscode";
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
