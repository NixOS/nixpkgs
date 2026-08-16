{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-Fy745lZuOz7lLPRp6XXmHGr9asLj2kynlJbaHe6kgCg=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-AULA4binavpDoxwpfpdBnl81HshNuChYiyOjte+aQw4=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-DKu+dUPCDNOCm1KlpNIeIPmIAFYbVQLD8w4Q3dy3pPI=";
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
    version = "1.2.8";
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
