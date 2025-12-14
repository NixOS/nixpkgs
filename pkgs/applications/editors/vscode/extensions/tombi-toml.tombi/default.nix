{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-YoB9gH84F9h6vdRbgCJGQhBmcXQ6jzrxvF2hA7gb3aI=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-IDJJuSLNt0SxV8LdDX0JC3P+VR6NUAfe5u8p9vI+ik8=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-gDufj8XYlowpKd2MQMZBsnZ2eT/pbngDlKeIFlkUKzU=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-biWq6nsO4XGOMSUA9/yXMejC1wTDKsuQdPU26w0r4Lg=";
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
    version = "0.7.7";
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
