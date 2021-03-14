{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kanboard";
  version = "1.2.18";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "sha256-raXPRoydd3CfciF7S0cZiuY7EPFKfE8IU3qj2dOztHU=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/kanboard
    cp -rv . $out/share/kanboard
  '';

  meta = with lib; {
    description = "Kanban project management software";
    homepage = "https://kanboard.net";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz lheckemann ];
  };
}
