{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "bgpq3";
  version = "0.1.38";

  src = fetchFromGitHub {
    owner = "snar";
    repo = "bgpq3";
    rev = "v${version}";
    hash = "sha256-rqZI7yqlVHfdRTOsA5V6kzJ2TGCy8mp6yP+rzsQX9Yc=";
  };

  meta = with lib; {
    description = "bgp filtering automation tool";
    homepage = "https://github.com/snar/bgpq3";
    license = licenses.bsd2;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = with platforms; unix;
    mainProgram = "bgpq3";
  };
}
