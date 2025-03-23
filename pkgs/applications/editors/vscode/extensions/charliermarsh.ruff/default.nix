{
  stdenvNoCC,
  lib,
  vscode-utils,
  ruff,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-XRdrZ+NHqtv7KCAvk0PX99SQxVDhdnbNOszqXdTnFnk=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-zeIcmlQTRugMNLqHTnxWvAd//CUqo1i4W4lPhzmZga8=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-ynJjsvSywU8s81tifUun4wwxJTMBm+zNmZDeuMzWY2k=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-rgdiYnhNMEoZwwN7jUJ/sucgSXSVqrJA+X3t0Sjv/Q8=";
        };
      };
    in
    {
      name = "ruff";
      publisher = "charliermarsh";
      version = "2025.14.0";
    }
    // sources.${stdenvNoCC.system} or (throw "Unsupported system ${stdenvNoCC.system}");

  postInstall = ''
    test -x "$out/$installPrefix/bundled/libs/bin/ruff" || {
      echo "Replacing the bundled ruff binary failed, because 'bundled/libs/bin/ruff' is missing."
      echo "Update the package to the match the new path/behavior."
      exit 1
    }
    ln -sf ${lib.getExe ruff} "$out/$installPrefix/bundled/libs/bin/ruff"
  '';

  meta = {
    license = lib.licenses.mit;
    changelog = "https://marketplace.visualstudio.com/items/charliermarsh.ruff/changelog";
    description = "Visual Studio Code extension with support for the Ruff linter";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff";
    homepage = "https://github.com/astral-sh/ruff-vscode";
    maintainers = [ lib.maintainers.azd325 ];
  };
}
