{
  vscode-utils,
  lib,
  nixpkgs-fmt,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "nixpkgs-fmt";
    publisher = "B4dM4n";
    version = "0.0.1";
    hash = "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
  };
  executableConfig."nixpkgs-fmt.path".package = nixpkgs-fmt;
  meta = {
    license = lib.licenses.mit;
  };
}
