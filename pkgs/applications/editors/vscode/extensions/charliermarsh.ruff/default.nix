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
          hash = "sha256-Rf8cx11qoXxFdPoItXSsEFc/QvLxYnyEt46Fv9fZdWw=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-t97dol5FTLl2gSi3HbI4S7YpHcRygfBNcpNhWnlO1Xc=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-BRkebtBrOVD/usNbu1TOXxklrLyKIOxSgzZEeBlhRAo=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-us/4xn6IO09MZApja9KwdD+0HIKm5+cmG/kmggJ6mC8=";
        };
      };
    in
    {
      name = "ruff";
      publisher = "charliermarsh";
      version = "2025.28.0";
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
