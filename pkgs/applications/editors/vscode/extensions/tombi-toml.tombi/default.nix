{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-tV6dDvxAitdLr1q60hpVmBkhn6uqjgo2HzdugnSqH/M=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-o99w6B4D7x4oHcv2GKRKkfhjXv2QGvAj4fJVPpFyvJk=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-SqEpJ3bIksDIeDxYYOiOZmoyiTZcm6mosXw7Q/QTY8o=";
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
    version = "1.4.1";
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
