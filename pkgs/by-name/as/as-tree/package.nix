{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "as-tree";
  version = "unstable-2021-03-09";

  src = fetchFromGitHub {
    owner = "jez";
    repo = "as-tree";
    rev = "0036c20f66795774eb9cda3ccbae6ca1e1c19444";
    hash = "sha256-80yB89sKIuv7V68p0jEsi2hRdz+5CzE+4R0joRzO7Dk=";
  };

  cargoHash = "sha256-HTwzmfpp9HKBKvjYXUqVDv9GUHl+2K3LMBSy1+GfmNU=";

  meta = {
    description = "Print a list of paths as a tree of paths";
    homepage = "https://github.com/jez/as-tree";
    license = with lib.licenses; [ blueOak100 ];
    maintainers = with lib.maintainers; [ jshholland ];
    mainProgram = "as-tree";
  };
}
