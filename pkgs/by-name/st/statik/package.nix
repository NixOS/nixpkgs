{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "statik";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = "statik";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-GfXYlkzPESu9Szl+g90oB2ldrCS5aAOt9m+WPOOXhIE=";
  };

  vendorHash = null;

  # Avoid building example
  subPackages = [
    "."
    "fs"
  ];
  # Tests are checking that the files embedded are preserving
  # their meta data like dates etc, but it assumes to be in 2048
  # which is not the case once entered the nix store
  doCheck = false;

  meta = {
    homepage = "https://github.com/rakyll/statik";
    description = "Embed files into a Go executable";
    mainProgram = "statik";
    license = lib.licenses.asl20;
  };
})
