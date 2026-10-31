{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-pIecZPe2514vlaliUkPL6dzbZmSzApJqkUjRvDVGplc=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-dqF+KY6Nzr4SUfp3ToYN6uNFpA1xXhJAnv0jIgOFnjs=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-PH4PEjhFS9wzvF2iq1E9OrslYrtag5x6NrBMdALhA4c=";
      arch = "darwin-arm64";
    };
  };

  base =
    supported.${stdenv.hostPlatform.system}
      or (throw "unsupported platform ${stdenv.hostPlatform.system}");

in

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = base // {
    name = "tombi";
    publisher = "tombi-toml";
    version = "1.8.9";
  };
  meta = {
    description = "TOML Language Server";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tombi-toml.tombi";
    homepage = "https://tombi-toml.github.io/tombi/";
    license = lib.licenses.mit;
    platforms = builtins.attrNames supported;
    maintainers = [ lib.maintainers.m0nsterrr ];
  };
}
