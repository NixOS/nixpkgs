{
  stdenv,
  lib,
  vscode-utils,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-DWrKvjWpUYvyqgZCShqwBKw33MHW31cxb4ERV65O+uc=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-CYDutYtU0+AAn6PYO/EQ/Suv8BNuMtvePpFdKRtiqAs=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-iFHeZiTubXA/t2Gib9hP42d7yjq/WRyywp+l8VhGfmo=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-qe7K3PQIgZztIdOVx37LGXrzBmYui2o2CcmDK+5jaFM=";
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
    version = "1.1.7";
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
