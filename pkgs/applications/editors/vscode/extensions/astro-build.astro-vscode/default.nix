{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "astro-vscode";
    publisher = "astro-build";
    version = "2.17.5";
    hash = "sha256-Et49KN7ZWg3RXaqcMJTrfx3kqTZbnsVa8QFhc5FQjnQ=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/astro-build.astro-vscode/changelog";
    description = "Astro language support for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=astro-build.astro-vscode";
    homepage = "https://github.com/withastro/language-tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      frontear
    ];
  };
}
