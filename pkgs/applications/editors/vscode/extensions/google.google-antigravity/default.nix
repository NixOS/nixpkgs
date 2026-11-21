{
  lib,
  vscode-utils,
  antigravity-cli,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "google-antigravity";
    publisher = "google";
    version = "1.11.0";
    hash = "sha256-KKhUKxsPYvuZhgkFTZemm2fMm/rLbrl0US7G5Jbo9Lg=";
  };

  postPatch = ''
    substituteInPlace extension.js \
      --replace-fail \
        'Va.CDE_PREINSTALLED_BINARY_PATH="/usr/bin/agy"' \
        'Va.CDE_PREINSTALLED_BINARY_PATH="${lib.getExe antigravity-cli}"' \
      --replace-fail \
        'oa.CdeAuthService.getInstance().isCdeEnvironment()&&(0,la.existsSync)(a)?a:cc()' \
        '(0,la.existsSync)(a)?a:cc()' \
      --replace-fail \
        'if(oa.CdeAuthService.getInstance().isCdeEnvironment()){let qc=q!=null?q:Va.CDE_PREINSTALLED_BINARY_PATH;' \
        'if(true){let qc=q!=null?q:Va.CDE_PREINSTALLED_BINARY_PATH;'
  '';

  meta = {
    changelog = "https://antigravity.google/docs/changelog?tab=extensions&ide=vscode";
    description = "Visual Studio Code extension to bring Google's agent-first development platform to VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Google.google-antigravity";
    homepage = "https://antigravity.google";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seirl ];
    platforms = antigravity-cli.meta.platforms;
  };
}
