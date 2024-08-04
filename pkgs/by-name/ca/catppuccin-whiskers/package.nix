{ lib, fetchFromGitHub, rustPlatform }:
let version = "2.4.0";
in rustPlatform.buildRustPackage {
  pname = "catppuccin-whiskers";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "whiskers";
    rev = "refs/tags/v${version}";
    hash = "sha256-rbPr5eSs99nS70J785SWO7tVBdiX/S7XUNHuo3aOQU4=";
  };

  cargoHash = "sha256-T7dreELSHfJizfbJEvvgkOmkMwlOETZVUdLwRFJOJEo=";

  meta = {
    homepage = "https://github.com/catppuccin/whiskers";
    description = "A templating tool to simplify the creation of Catppuccin ports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Name ];
    mainProgram = "whiskers";
  };
}
