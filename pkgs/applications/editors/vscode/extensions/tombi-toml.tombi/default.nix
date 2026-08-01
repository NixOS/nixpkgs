{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-C+8B/YO1u3AIP1tv3Bil9ljh2UXfDfrmYPbZykhEdoM=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-MKPAQhFgPjTzYzgiSXEUNXOBC1EcsstdAfRdxeCQ7c0=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-FFYr9p5pg1C25fFc+swGrKvF0WVAIJhOMKCSY3fsJpA=";
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
    version = "1.2.4";
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
