{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-M9rpB2W+r8ztmCHmfnbMCiKlsXesC1e5jWgoMOCIbR4=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-XhJ4ZAzTyW8aMf3iTtgNZkSasRRq/kGSt6jrGdwfu7Q=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-ky6kGUwZ4Wuplwsl+0gofCi4J0TdAnCsH7fcQ7UEN6Y=";
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
    version = "1.11.3";
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
