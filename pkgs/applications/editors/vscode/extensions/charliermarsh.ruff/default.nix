{
  stdenvNoCC,
  lib,
  vscode-utils,
  ruff,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-brdR9U8LQ0UKTjKez5navXFNO14XBzVw2a+F7/GQP28=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-SOxQMrTizhJKc7I6w64XY1BNqsPkWBZK69L6+GU6YXo=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-rAYGc/1g8NFAmsEEvVI9SoXP3+4xVjzd3sdQeSkXT/w=";
        };
      };
    in
    {
      name = "ruff";
      publisher = "charliermarsh";
      version = "2026.72.0";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  postInstall = ''
    test -x "$out/$installPrefix/bundled/libs/bin/ruff" || {
      echo "Replacing the bundled ruff binary failed, because 'bundled/libs/bin/ruff' is missing."
      echo "Update the package to the match the new path/behavior."
      exit 1
    }
    ln -sf ${lib.getExe ruff} "$out/$installPrefix/bundled/libs/bin/ruff"
  '';

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    license = lib.licenses.mit;
    changelog = "https://marketplace.visualstudio.com/items/charliermarsh.ruff/changelog";
    description = "Visual Studio Code extension with support for the Ruff linter";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff";
    homepage = "https://github.com/astral-sh/ruff-vscode";
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
    ];
    maintainers = [ lib.maintainers.azd325 ];
  };
}
