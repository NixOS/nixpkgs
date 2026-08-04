{
  lib,
  writeShellScript,
  vscode-utils,
  jq,
  moreutils,
  languageserver ? rPackages.languageserver,
  rWrapper,
  radian,
  rPackages,
}:

let
  rWithLanguageServer = rWrapper.override { packages = [ languageserver ]; };
  preferPath =
    name: fallback:
    writeShellScript "${name}-path-first" ''
      if command -v ${name} > /dev/null 2>&1; then
        exec ${name} "$@"
      fi
      exec ${fallback} "$@"
    '';
  rPathFirst = preferPath "R" (lib.getExe' rWithLanguageServer "R");
  radianPathFirst = preferPath "radian" (lib.getExe radian);
in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "r";
    publisher = "reditorsupport";
    version = "2.8.8";
    hash = "sha256-mt2bes7aHcAHLMngSLW/zI3kSIzNKALqX+g0UXo84uI=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."r.rpath.mac".default = "${rPathFirst}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.rpath.linux".default = "${rPathFirst}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.rterm.mac".default = "${radianPathFirst}"' package.json | sponge package.json
    jq '.contributes.configuration.properties."r.rterm.linux".default = "${radianPathFirst}"' package.json | sponge package.json
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
