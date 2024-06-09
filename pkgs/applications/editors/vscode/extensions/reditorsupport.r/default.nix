{
  lib,
  vscode-utils,
  jq,
  moreutils,
  python311Packages,
  R,
  rPackages,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "r";
    publisher = "reditorsupport";
    version = "2.8.4";
    hash = "sha256-wVT9/JUuqP8whW99q1gwVMf7PRzgZNLoIdlXsclpbck=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  buildInputs = [
    python311Packages.radian
    R
    rPackages.languageserver
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."r.rpath.mac".default = "${lib.getExe' R "R"}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.rpath.linux".default = "${lib.getExe' R "R"}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.rterm.mac".default = "${lib.getExe python311Packages.radian}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.rterm.linux".default = "${lib.getExe python311Packages.radian}"' package.json | sponge package.json
  '';
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/REditorSupport.r/changelog";
    description = "A Visual Studio Code extension for the R programming language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=REditorSupport.r";
    homepage = "https://github.com/REditorSupport/vscode-R";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pandapip1 ];
  };
}
