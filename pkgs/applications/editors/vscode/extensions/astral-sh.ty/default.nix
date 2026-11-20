{
  stdenvNoCC,
  lib,
  vscode-utils,
  ty,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-A9cFMhVMC+duJmRIbWcVWExZdAtDi7bj95cphL8FQ1g=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-//xadLpMq3b/vIfK93Gd3yCwAvpSRqJ7NdvpFtRgDRE=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-pGW+TEc69V50dmDdgbqBeFSrzRjfIVxp9NUX+CGQ84g=";
        };
      };
    in
    {
      name = "ty";
      publisher = "astral-sh";
      version = "2026.76.0";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  postInstall = ''
    test -x "$out/$installPrefix/bundled/libs/bin/ty" || {
      echo "Replacing the bundled ty binary failed, because 'bundled/libs/bin/ty' is missing."
      echo "Update the package to the match the new path/behavior."
      exit 1
    }
    ln -sf ${lib.getExe ty} "$out/$installPrefix/bundled/libs/bin/ty"
  '';

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    license = lib.licenses.mit;
    changelog = "https://marketplace.visualstudio.com/items/astral-sh.ty/changelog";
    description = "Visual Studio Code extension with support for the ty type checker and language server";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=astral-sh.ty";
    homepage = "https://github.com/astral-sh/ty-vscode";
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
    ];
    maintainers = [ lib.maintainers.thegu5 ];
  };
}
