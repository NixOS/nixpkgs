{
  lib,
  vscode-utils,
  languageserver ? rPackages.languageserver,
  R,
  radian,
  rPackages,
  buildPackages,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "r";
    publisher = "reditorsupport";
    version = "3.2.0";
    hash = "sha256-+/0drSLFq2lnUNIB1HMs4wwDLyImXU7+KyIOtDYe/R4=";
  };
  defaultConfig = {
    "r.rpath.mac" = R;
    "r.rpath.linux" = R;
    "r.rterm.mac" = radian;
    "r.rterm.linux" = radian;
  };
  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe buildPackages.jq} -e '
      .contributes.configuration.properties."r.libPaths".default =
        [ "${languageserver}/library" ]
    ' package.json | ${lib.getExe' buildPackages.moreutils "sponge"} package.json
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
