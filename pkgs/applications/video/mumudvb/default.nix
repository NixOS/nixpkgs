{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "mumudvb-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    repo = "MuMuDVB";
    owner = "braice";
    rev = "${version}";
    sha256 = "0ym7xlpng0k2048wk77gcm0xbbjz6a766dl0qpdicmzc2bcj1l4m";
  };

  buildInputs = [ autoreconfHook ];

  meta = {
    description = "Redistributes streams from DVB or ATSC on a network";
    homepage = http://mumudvb.net/;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ] ;
    license = stdenv.lib.licenses.gpl2;
  };
}
