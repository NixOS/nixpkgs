{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
let
  version = "0.5.1";
in
buildGoModule {
  pname = "ardugotools";
  inherit version;

  src = fetchFromGitHub {
    owner = "randomouscrap98";
    repo = "ardugotools";
    rev = "refs/tags/v${version}";
    hash = "sha256-c+sJoE5NML06bl6ch+OiN1vO0rdyE2gf/z4pzY7i5Qk=";
  };

  vendorHash = "sha256-Z9ObsS+GwVsz6ZlXCgN0WlShHzbmx4WLa/1/XLSSAAs=";

  meta = {
    description = "CLI toolset for Arduboy";
    changelog = "https://github.com/randomouscrap98/ardugotools/releases/tag/v${version}";
    homepage = "https://github.com/randomouscrap98/ardugotools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "ardugotools";
  };
}
