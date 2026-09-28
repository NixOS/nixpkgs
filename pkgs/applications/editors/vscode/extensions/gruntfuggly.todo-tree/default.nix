{
  jq,
  lib,
  moreutils,
  ripgrep,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "todo-tree";
    publisher = "Gruntfuggly";
    version = "0.0.226";
    hash = "sha256-Fj9cw+VJ2jkTGUclB1TLvURhzQsaryFQs/+f2RZOLHs=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    jq
    moreutils
  ];

  buildInputs = [ ripgrep ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '(.contributes.configuration[] | select(.title == "%todo-tree.configuration.regex%") | .properties."todo-tree.ripgrep.ripgrep".default) = $s' \
      --arg s "${lib.getExe ripgrep}" \
      package.json | sponge package.json
  '';

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/Gruntfuggly.todo-tree/changelog";
    description = "Show TODO, FIXME, etc. comment tags in a tree view";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree";
    homepage = "https://github.com/Gruntfuggly/todo-tree";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
  };
}
