{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-YLic8tKnb6WSx4rdwTu8B2ybfjoSbXc+QfEZ0Vc4umo=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-nbftXgjEAxGfT4sfTjd+bp+Ti/rWJGHLkaSXQWlRGBM=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-FG6OIoeeDenMbgwM/ZE8YyTySt/XcoFJj1RxvlrPsXc=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-FW+pmz8YTw6pYxx1x3UsT3Dtp00GT804MJX4HBarMZo=";
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
    version = "1.1.5";
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
