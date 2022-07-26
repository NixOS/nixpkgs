{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kanboard";
  version = "1.2.22";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "sha256-pLxCm+T9jdn0FFqbTFe1tsIPTaVTT+QDeLHDxrbpGBg=";
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
