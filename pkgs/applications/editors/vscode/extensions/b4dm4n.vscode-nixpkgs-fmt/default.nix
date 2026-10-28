{
  vscode-utils,
  jq,
  lib,
  moreutils,
  nixpkgs-fmt,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "nixpkgs-fmt";
    publisher = "B4dM4n";
    version = "0.0.1";
    hash = "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."nixpkgs-fmt.path".default = "${nixpkgs-fmt}/bin/nixpkgs-fmt"' package.json | sponge package.json
  '';
  meta = {
    license = lib.licenses.mit;
  };
}
