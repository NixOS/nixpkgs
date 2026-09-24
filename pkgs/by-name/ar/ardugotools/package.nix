{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "0.6.2";
in
buildGoModule {
  pname = "ardugotools";
  inherit version;

  src = fetchFromGitHub {
    owner = "randomouscrap98";
    repo = "ardugotools";
    rev = "v${version}";
    hash = "sha256-kqFXJIHyPvm3Fq/qsojdltS99Wb4Qc/wPc6tw4n9pKs=";
  };

  vendorHash = "sha256-sC47I3dKmQrF1ux+yYRyl6xB+cU1Yve/K+9wh3HQyik=";

  checkFlags =
    let
      # Skip tests referencing a non-existing file
      skippedTests = [
        "TestRunLuaFlashcartGenerator_CategoriesOnly"
        "TestRunLuaFlashcartGenerator_FullCart"
        "TestRunLuaFlashcartGenerator_MakeCart"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "CLI toolset for Arduboy";
    changelog = "https://github.com/randomouscrap98/ardugotools/releases/tag/v${version}";
    homepage = "https://github.com/randomouscrap98/ardugotools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "ardugotools";
  };
}
