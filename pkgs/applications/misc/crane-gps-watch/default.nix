{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "crane-gps-watch-${version}";
  version = "20160308";
  src = fetchFromGitHub {
    owner = "mru00";
    repo = "crane_gps_watch";
    rev = "221f99dc2925a07658f7b6e01789ced1a18cc08c";
    sha256 = "0ji50yg85a114pdvw8k5jgfxq312frlxq67bazfaws9mkhnkpi9v";
  };

meta = with stdenv.lib; {
  inherit (src.meta) homepage;
  description = "Crane GPS Watch client";
  license = stdenv.lib.licenses.gpl3;
  maintainers = [ maintainers.AcouBass ];
  platforms = platforms.linux;
  };
}
