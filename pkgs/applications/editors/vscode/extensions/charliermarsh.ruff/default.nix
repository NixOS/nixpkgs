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
          hash = "sha256-lGV/Zc4pibm7sTVtN4UYzuroxNgUltaUT9oJPaa5S8Q=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-h1cvTJ9VUHOL27F9twdbLTSzLb+NUhqrbaScoKF5jZ4=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Ca9DGjQDT5BbJUL7FtU3dS6Zb7C2Blxr69l5HpZR4ZQ=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-8Qay/ynixASQ8FFyAYjBeGcjBKQGXucGlOndOYa1Fn8=";
        };
      };
    in
    {
      name = "ruff";
      publisher = "charliermarsh";
      version = "2025.22.0";
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
      "x86_64-darwin"
    ];
    maintainers = [ lib.maintainers.azd325 ];
  };
}
