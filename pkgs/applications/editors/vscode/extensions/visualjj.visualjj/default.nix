{
  lib,
  stdenv,
  vscode-utils,
  fetchurl,
}:

let
  version = "0.12.5";

  sources = {
    "x86_64-linux" = {
      arch = "linux-x64";
      url = "https://download.visualjj.com/visualjj-linux-x64-${version}.vsix";
      hash = "sha256-wby6xz+pKVZDoAdF3Onkc6/rqMN8zh/b+9Phd7Q9yyo=";
    };
    "x86_64-darwin" = {
      arch = "darwin-x64";
      url = "https://download.visualjj.com/visualjj-darwin-x64-${version}.vsix";
      hash = "sha256-MrnXlvdE17yq8UdFPLOBE7z9hEIZ4mDj56SxXHZTttI=";
    };
    "aarch64-linux" = {
      arch = "linux-arm64";
      url = "https://download.visualjj.com/visualjj-linux-arm64-${version}.vsix";
      hash = "sha256-F3u1NF1JqZhcJjW9MCIV9iwuhSX1MJ2d/8ndghpUqPI=";
    };
    "aarch64-darwin" = {
      arch = "darwin-arm64";
      url = "https://download.visualjj.com/visualjj-darwin-arm64-${version}.vsix";
      hash = "sha256-rgqArEjpS0Kc89MUBmdbBtK0l94fJfw8vRSwuz3CJC4=";
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
