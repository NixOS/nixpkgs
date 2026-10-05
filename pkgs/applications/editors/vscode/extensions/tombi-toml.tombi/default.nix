{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-yDOQ1WYX9yt5nQkzTIRfSmDAQvPbusgkz9OS26nrTgY=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-TR8pA3F36t3SHVnLwAMUSBl5/G5EOd2rEO7MCzjopCg=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-K3bPccJzf0KRKOjuGp0OkAPyltr4yNk8amZkWI7WIig=";
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
    version = "1.5.8";
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
