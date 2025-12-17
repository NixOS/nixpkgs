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
          hash = "sha256-oN7pb/KKhzx7LgODvEh5GyX9Nismtz1lsDcGsDlmaO0=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-MeX4waPhX4/hmQH+iYs+RZlRGC/giXOtXG31zSAzcKI=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-pALbGD8Gikfyn4wNjCK9CTwZzaK/LjfHfJmFW0ns+yo=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-Tr6KjEDTtCH3EgSKK0WqU/5w8gjSz3azhxHVHlXwZTw=";
        };
      };
    in
    {
      name = "ruff";
      publisher = "charliermarsh";
      version = "2025.32.0";
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
