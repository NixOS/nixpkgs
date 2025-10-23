{
  lib,
  vscode-utils,
  jq,
  moreutils,
  languageserver ? rPackages.languageserver,
  R,
  radian,

  rPackages,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "r";
    publisher = "reditorsupport";
    version = "2.8.6";
    hash = "sha256-T/Qh0WfTfXMzPonbg9NMII5qFptfNoApFFiZCT5rR3Y=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."r.rpath.mac".default = "${lib.getExe' R "R"}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.rpath.linux".default = "${lib.getExe' R "R"}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.rterm.mac".default = "${lib.getExe radian}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.rterm.linux".default = "${lib.getExe radian}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.libPaths".default = [ "${languageserver}/library" ]' package.json | sponge package.json
  '';
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/REditorSupport.r/changelog";
    description = "Visual Studio Code extension for the R programming language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=REditorSupport.r";
    homepage = "https://github.com/REditorSupport/vscode-R";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.pandapip1
      lib.maintainers.ivyfanchiang
    ];
  };
}
