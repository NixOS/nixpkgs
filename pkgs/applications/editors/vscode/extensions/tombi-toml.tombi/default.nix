{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-5N10XAuSHkAbX+PGAkhaTc0XENyvcKhWbAIg7JHpzUo=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-SvBBjzTBXxCJ7Bgq9Hjjsl+E5zZQX7S96zsn9IN658I=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-nbxYoaoe1tDujzL9qdxPEhF3ICSQDOzSE/lMYh53HnA=";
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
    version = "1.9.8";
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
