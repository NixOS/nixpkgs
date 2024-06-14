{
  alejandra,
  jq,
  lib,
  moreutils,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "alejandra";
    publisher = "kamadorueda";
    version = "1.0.0";
    hash = "sha256-COlEjKhm8tK5XfOjrpVUDQ7x3JaOLiYoZ4MdwTL8ktk=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"

    jq -e '
      .contributes.configuration.properties."alejandra.program".default =
        "${lib.getExe alejandra}" |
      .contributes.configurationDefaults."alejandra.program" =
        "${lib.getExe alejandra}"
    ' \
    < package.json \
    | sponge package.json
  '';
  meta = {
    description = "Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.kamadorueda ];
  };
}
