{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-HECflrFni3eWxMs+BpjWBhU3pqF5jjMIEjkp9ibx784=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-dCkSOClWWq3DGU9psrinI5f5oC69K+AhdHdXwKIQsFw=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-XNIx2ibOe1/1lo8RkYkAv+oBDYpqnmMcIjpoulbrr+w=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-rXVuQN0SDmymQNncFZzyD4H+j6hxp1yoiaNXnbzrlo0=";
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
    version = "1.1.1";
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
