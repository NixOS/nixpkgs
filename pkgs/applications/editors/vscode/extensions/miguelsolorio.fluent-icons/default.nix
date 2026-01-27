{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef = {
    name = "fluent-icons";
    publisher = "miguelsolorio";
    version = "0.0.19";
    hash = "sha256-OfPSh0SapT+YOfi0cz3ep8hEhgCTHpjs1FfmgAyjN58=";
  };

  meta = {
    changelog = "https://github.com/miguelsolorio/vscode-fluent-icons/releases/tag/${finalAttrs.version}";
    description = "Fluent product icons for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=miguelsolorio.fluent-icons";
    homepage = "https://github.com/miguelsolorio/vscode-fluent-icons";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.iamanaws ];
  };
})
