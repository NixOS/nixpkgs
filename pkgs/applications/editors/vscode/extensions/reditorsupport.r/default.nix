{
  lib,
  vscode-utils,
  languageserver ? rPackages.languageserver,
  R,
  radian,
  rPackages,
  jq,
  moreutils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "r";
    publisher = "reditorsupport";
    version = "2.8.8";
    hash = "sha256-mt2bes7aHcAHLMngSLW/zI3kSIzNKALqX+g0UXo84uI=";
  };
  executableConfig = {
    "r.rpath.mac".package = R;
    "r.rpath.linux".package = R;
    "r.rterm.mac".package = radian;
    "r.rterm.linux".package = radian;
  };
  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe jq} -e '
      .contributes.configuration.properties."r.libPaths" =
        [ "${languageserver}/library" ]
    ' package.json | ${lib.getExe' moreutils "sponge"} package.json
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
