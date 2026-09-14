{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-PdUKx/IOMI9xegw8NmOqcAh6WZzizwNOVcbq4XgJED4=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-qBmWuA9hmJRGthMA38gHULPzjcf/JdR1XuXmUR3PWuY=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-N+kxQnaaCN+hIZ9WEaOuReEeiYa/N7Bd1/Z/NRL/gCQ=";
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
    version = "1.5.2";
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
