{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-B1ymOFv6CPGhlyA14wis7qn+JlHv09FOt0OYyPtnyEA=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-127gG0MZ+SikOLrDyQgmiPukkCXjR/tWOCmT9lDphBU=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-UJ515dYrIdP4EyZXSrI3OzM620WUHwlemd1mfoXRw4E=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-amlxTRVVIFmcXErvGBh2ZSXoSzJN1Pmr2uWcnRRpcJU=";
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
    version = "0.9.24";
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
