{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-LuES+anP3Kd1uOZrteb3yy5nsec5gAX0PYeslJ8orBg=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-vMLc5Yhtif8jN9V7DXER8BxFxYYv3sY7yKNMvse6CmQ=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-0ktwL6NkSGrpIUzc0IARoql2hxcluxvK0CTZkX4UEUE=";
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
    version = "1.2.5";
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
