{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "bgpq3";
  version = "0.1.36.1";

  src = fetchFromGitHub {
    owner = "snar";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rOpggVlXKaf3KBhfZ2lVooDaQA0iRjSbsLXF02GEyBw=";
  };

  meta = {
    description = "bgp filtering automation tool";
    homepage = "https://github.com/snar/bgpq3";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ b4dm4n ];
    platforms = with lib.platforms; unix;
    mainProgram = "bgpq3";
  };
}
