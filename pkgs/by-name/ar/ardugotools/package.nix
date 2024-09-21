{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
let
  version = "0.6.1";
in
buildGoModule {
  pname = "ardugotools";
  inherit version;

  src = fetchFromGitHub {
    owner = "randomouscrap98";
    repo = "ardugotools";
    rev = "v${version}";
    hash = "sha256-SqeUcYa8XscwaJaCSIoZ9lEtRJ0hN01XJDyCJFX2dTc=";
  };

  vendorHash = "sha256-Z9ObsS+GwVsz6ZlXCgN0WlShHzbmx4WLa/1/XLSSAAs=";

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
