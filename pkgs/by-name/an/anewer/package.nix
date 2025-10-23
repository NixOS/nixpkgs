{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "anewer";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ysf";
    repo = "anewer";
    tag = version;
    sha256 = "181mi674354bddnq894yyq587w7skjh35vn61i41vfi6lqz5dy3d";
  };

  cargoHash = "sha256-ojgm5LTOOhnGS7tUD1UUktviivp68u0c06gIJNhEO1E=";

  meta = with lib; {
    description = "Append lines from stdin to a file if they don't already exist in the file";
    mainProgram = "anewer";
    homepage = "https://github.com/ysf/anewer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
