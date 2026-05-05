{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-eij6YR9wpll8n+Za4PNz9Q+Q0MQn22o9uxIxiglI8DY=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-9/cR5wUcT77kwnt6on4qysqiqkvUpXhYwCHOVYZQybI=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-eO8Po6E4oH2wNJ0MEBQas5NOdSYNRgbjDbqJ2YRSdA4=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-PuTRUIXbRD5dZ/3IGEw/N74Eyjb6UpDa06UnTH9N4kg=";
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
    version = "0.10.3";
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
