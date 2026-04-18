{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-1N2D1+5AZionGw0pfuf9PW+Pfc3AI/v9BmqLiue/YZA=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-izM0qVgTNJ2G5SDnULaNWWuI+VwWTNx95bU8O4sIa64=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-tcjzqbGlycVDgJbHuuVUMvrBWU/UD4Y+kah9swny3Ws=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-gP7w+wCzUMjwI7Lk9aklzv2Wo6R0zdpVKoDwKw6HPhQ=";
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
    version = "0.9.18";
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
