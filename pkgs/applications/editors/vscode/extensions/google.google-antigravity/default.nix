{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "google-antigravity";
    publisher = "google";
    version = "1.11.0";
    hash = "sha256-KKhUKxsPYvuZhgkFTZemm2fMm/rLbrl0US7G5Jbo9Lg=";
  };

  meta = {
    changelog = "https://antigravity.google/docs/changelog?tab=extensions&ide=vscode";
    description = "Visual Studio Code extension to bring Google's agent-first development platform to VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Google.google-antigravity";
    homepage = "https://antigravity.google";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seirl ];
  };
}
