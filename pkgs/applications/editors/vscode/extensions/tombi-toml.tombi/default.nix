{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-fGcPMeJKJE3QRy85xUWbYemjtKMQ6Tlx181qyBXfGd8=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-rXpGVuOtCTvuHQQVVB+KMMrGsKEJz9pBpzu6VWLm4M8=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-tS1kyYLg8+tIE+eFhSUzQWymYDX8aw9oOB0chsIrp+M=";
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
    version = "1.7.3";
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
