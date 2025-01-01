{
  lib,
  stdenv,
  vscode-utils,
  fetchurl,
}:

let
  version = "0.13.0";

  sources = {
    "x86_64-linux" = {
      arch = "linux-x64";
      url = "https://download.visualjj.com/visualjj-linux-x64-${version}.vsix";
      hash = "sha256-mhfn/Lw/W1T2PaIglwrO/7VacDutT6Tgs133ePHL7W4=";
    };
    "x86_64-darwin" = {
      arch = "darwin-x64";
      url = "https://download.visualjj.com/visualjj-darwin-x64-${version}.vsix";
      hash = "sha256-feghMmcqzFM/Ttk8s4fp8et9Suw2kKLocptzwEcB2Sw=";
    };
    "aarch64-linux" = {
      arch = "linux-arm64";
      url = "https://download.visualjj.com/visualjj-linux-arm64-${version}.vsix";
      hash = "sha256-bfBj/A41FFMwMAEVw77nEDyk0+fYvi2Tg1Ufihxi9F8=";
    };
    "aarch64-darwin" = {
      arch = "darwin-arm64";
      url = "https://download.visualjj.com/visualjj-darwin-arm64-${version}.vsix";
      hash = "sha256-xzf3WrH7BTiaX6NC2n9nLCKuBlFzRDYaSR73VGM7Ldc=";
    };
  };
in
vscode-utils.buildVscodeMarketplaceExtension {
  vsix = fetchurl {
    url = sources.${stdenv.hostPlatform.system}.url;
    hash = sources.${stdenv.hostPlatform.system}.hash;
    name = "visualjj-visualjj-${version}.zip";
  };

  mktplcRef = {
    inherit version;
    name = "visualjj";
    publisher = "visualjj";
    arch = sources.${stdenv.hostPlatform.system}.arch;
  };

  meta = {
    description = "Jujutsu version control integration, for simpler Git workflow";
    downloadPage = "https://www.visualjj.com";
    homepage = "https://www.visualjj.com";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.drupol ];
  };
}
