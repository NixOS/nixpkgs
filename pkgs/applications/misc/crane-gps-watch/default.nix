{ stdenv, fetchFromGitHub, libxml2 }:

stdenv.mkDerivation rec {
  name = "crane-gps-watch";
  src = fetchFromGitHub {
    owner = "mru00";
    repo = "crane_gps_watch";
    rev = "221f99dc2925a07658f7b6e01789ced1a18cc08c";
    sha256 = "0ji50yg85a114pdvw8k5jgfxq312frlxq67bazfaws9mkhnkpi9v";
  };

meta = {
  homepage = "https://www.github.com/mru00/crane_gps_watch";
  description = "Crane GPS Watch client for Linux and Windows";
  license = stdenv.lib.licenses.gpl3;
  };
}