{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "frei";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "alexcoder04";
    repo = "frei";
    rev = "v${version}";
    sha256 = "sha256-C70c/uADy/D2YARRYROkc6Bs/VtYH3SIXUjSF3+qVjY=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Modern replacement for free";
    homepage = "https://github.com/alexcoder04/frei";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "frei";
  };
}
