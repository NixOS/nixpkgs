{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-gdyO/zg0NS8Md0o8WG96/0SrMw+VdJnRge6Io16l30Q=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-MLj1xREDTZCrWVsTZGifSUNFKKMLGDtF3xV9kIR3umQ=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-4fy778ogxyuN6irrAO9ZTHAMH9Va/QjF4PoHEZCBdFY=";
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
    version = "1.5.5";
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
