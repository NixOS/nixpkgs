{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-8KZE2+kpzU7fRRBsroZtCnJyPyUHPuysZrggZojpG98=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-Zf/O2KRDlzCi4qWnmT5CctagjJoLiNgZfnh5+gQWRAA=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-zN49L+gLrLNL7XM3+POgBgSX64IMUYtNZ54+i8lpLqE=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-vTf86rNeS/97//1D2e1h5DpnAFb1cceIuF5XyCCq520=";
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
    version = "1.1.3";
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
