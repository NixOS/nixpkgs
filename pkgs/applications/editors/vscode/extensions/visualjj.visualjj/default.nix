{
  lib,
  stdenv,
  vscode-utils,
  fetchurl,
}:

let
  version = "0.12.2";

  sources = {
    "x86_64-linux" = {
      arch = "linux-x64";
      url = "https://download.visualjj.com/visualjj-linux-x64-${version}.vsix";
      hash = "sha256-42xUp1HDnu1YZwXYgBhqshNzA0sx7VZLZzSaQypZb1M=";
    };
    "x86_64-darwin" = {
      arch = "darwin-x64";
      url = "https://download.visualjj.com/visualjj-darwin-x64-${version}.vsix";
      hash = "sha256-RFxhGKQpQnMbwuYfHQolFRJxI61hzog2A44x7W39yKw=";
    };
    "aarch64-linux" = {
      arch = "linux-arm64";
      url = "https://download.visualjj.com/visualjj-linux-arm64-${version}.vsix";
      hash = "sha256-KHeg2wAe1aynwAbQh5Do/rCbk2bqLZ3iIrYpDFRIw/E=";
    };
    "aarch64-darwin" = {
      arch = "darwin-arm64";
      url = "https://download.visualjj.com/visualjj-darwin-arm64-${version}.vsix";
      hash = "sha256-3y/MhxDgQBnbQ2OYLYFcl7488sKE7iVO4YhUhmQyCIM=";
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
