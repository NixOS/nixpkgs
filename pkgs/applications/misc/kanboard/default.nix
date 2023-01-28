{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kanboard";
  version = "1.2.26";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "sha256-/Unxl9Vh9pEWjO89sSviGGPFzUwxdb1mbOfpTFTyRL0=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/kanboard
    cp -rv . $out/share/kanboard
  '';

  meta = with lib; {
    description = "Kanban project management software";
    homepage = "https://kanboard.org";
    license = licenses.mit;
    maintainers = with maintainers; [ lheckemann ];
  };
}
