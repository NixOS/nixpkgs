{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-2LeIIUd3rl/97uEOIsOmJ7I3Htxw5zgJ2NsSoQMF784=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-xHdU87SXWDqWtRBKmajh3Ymyn3FeMPbNrENxmHiWbvQ=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-+NJfVDJX/gHa8/mK9I/2T1MZIlaywxnxLQ9T52sFDCI=";
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
    version = "1.11.2";
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
