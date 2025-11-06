{
  lib,
  fetchFromGitHub,
  crystal_1_17,
  coreutils,
}:
let
  crystal = crystal_1_17;
in
crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    tag = "v${version}";
    hash = "sha256-2gEwgXjB6zcJQAdUGQfZFe8WcqT5fyb8Qbxk0qwn+c8=";
  };

  format = "make";
  installFlags = [ "INSTALL_BIN=${coreutils}/bin/install" ];

  meta = {
    description = "Static code analysis tool for Crystal";
    mainProgram = "ameba";
    homepage = "https://crystal-ameba.github.io";
    changelog = "https://github.com/crystal-ameba/ameba/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
