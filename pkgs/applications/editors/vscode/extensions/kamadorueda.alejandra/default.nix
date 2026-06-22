{
  alejandra,
  lib,
  vscode-utils,
  buildPackages,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "alejandra";
    publisher = "kamadorueda";
    version = "1.0.0";
    hash = "sha256-COlEjKhm8tK5XfOjrpVUDQ7x3JaOLiYoZ4MdwTL8ktk=";
  };
  executableConfig."alejandra.program".package = alejandra;
  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe buildPackages.jq} -e '
      .contributes.configurationDefaults."alejandra.program" =
        "${lib.getExe alejandra}"
    ' package.json | ${lib.getExe' buildPackages.moreutils "sponge"} package.json
  '';
  meta = {
    description = "Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.kamadorueda ];
  };
}
