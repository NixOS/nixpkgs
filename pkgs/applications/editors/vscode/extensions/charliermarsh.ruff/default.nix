{
  stdenvNoCC,
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-KiCTJbLDut0Az7BmcYPQbFweT94RWnsE+JYvqVZ2P7s=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-Szy+bE/42cNzcEa2yKCyvxr5OBqH2dPVgJnCS57z3nY=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Bw1gdrb40baSXdrIgM0tlCLa18aGpRv1q7YN5wJRjNs=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-xcHL/2dliPD69mNEsbEpbtn5QLV1P3gqu9ftDOn58qM=";
        };
      };
    in
    {
      name = "ruff";
      publisher = "charliermarsh";
      version = "2024.34.0";
    }
    // sources.${stdenvNoCC.system} or (throw "Unsupported system ${stdenvNoCC.system}");

  meta = {
    license = lib.licenses.mit;
    changelog = "https://marketplace.visualstudio.com/items/charliermarsh.ruff/changelog";
    description = "Visual Studio Code extension with support for the Ruff linter";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff";
    homepage = "https://github.com/astral-sh/ruff-vscode";
    maintainers = [ lib.maintainers.azd325 ];
  };
}
