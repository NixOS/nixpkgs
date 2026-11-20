{
  lib,
  stdenv,
  vscode-utils,
}:

let
  sources = {
    x86_64-linux = {
      arch = "linux-x64";
      hash = "sha256-FoSeTMDSSvkP7uh4nXTjWdAgIhZjuQ9AtzYjQOPJH7Q=";
    };
    aarch64-linux = {
      arch = "linux-arm64";
      hash = "sha256-JRGWsYoJAzACJDcd/RwpP1F9BAs/DJqcsi1rrLNkO4Y=";
    };
    aarch64-darwin = {
      arch = "darwin-arm64";
      hash = "sha256-RH9u3fi755jhpQHRF90iYJZGEtG0IGKNp0TsJx+6tGQ=";
    };
  };
  base =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = base // {
    name = "astro-vscode";
    publisher = "astro-build";
    version = "2.17.4";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/astro-build.astro-vscode/changelog";
    description = "Astro language support for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=astro-build.astro-vscode";
    homepage = "https://github.com/withastro/language-tools";
    license = lib.licenses.mit;
    platforms = lib.attrNames sources;
    maintainers = [ ];
  };
}
