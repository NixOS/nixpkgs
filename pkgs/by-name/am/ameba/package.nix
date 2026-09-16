{
  lib,
  fetchFromGitHub,
  crystal_1_19,
  coreutils,
}:
let
  crystal = crystal_1_19;
in
crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    tag = "v${version}";
    hash = "sha256-P2XirYKxq3Y6cjK5O013fPzag9uWR9jdetlLxX70ji4=";
  };

  format = "make";
  installFlags = [ "INSTALL_BIN=${coreutils}/bin/install" ];

  meta = {
    description = "Static code analysis tool for Crystal";
    mainProgram = "ameba";
    homepage = "https://crystal-ameba.org";
    changelog = "https://github.com/crystal-ameba/ameba/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
