{
  lib,
  stdenv,
  vscode-utils,
  fetchurl,
}:

let
  version = "0.12.3";

  sources = {
    "x86_64-linux" = {
      arch = "linux-x64";
      url = "https://download.visualjj.com/visualjj-linux-x64-${version}.vsix";
      hash = "sha256-dpvdWE0LL4PY2bzfRLazqP+VB9SSyhwnMLoOLsMmNJw=";
    };
    "x86_64-darwin" = {
      arch = "darwin-x64";
      url = "https://download.visualjj.com/visualjj-darwin-x64-${version}.vsix";
      hash = "sha256-81ahZTuIG5ukXm+gmVzg4RgryRTyOIBaQ6BvGLCXVp0=";
    };
    "aarch64-linux" = {
      arch = "linux-arm64";
      url = "https://download.visualjj.com/visualjj-linux-arm64-${version}.vsix";
      hash = "sha256-brheyxw4tHXF5Guzn8fzolQmcLQvOknPeAtGNPowcBk=";
    };
    "aarch64-darwin" = {
      arch = "darwin-arm64";
      url = "https://download.visualjj.com/visualjj-darwin-arm64-${version}.vsix";
      hash = "sha256-EgupFXNfKKkk3FgEmgYwsY/QdaTLlbghKIIHQcvLatY=";
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
