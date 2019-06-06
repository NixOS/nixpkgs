{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, mpd_clientlib, sphinx }:

stdenv.mkDerivation rec {
  pname = "mpc";
  version = "0.31";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "mpc";
    rev    = "v${version}";
    sha256 = "06wn5f24bgkqmhh2p8rbizmqibzqr4x1q7c6zl0pfq7mdy49g5ds";
  };

  buildInputs = [ mpd_clientlib ];

  nativeBuildInputs = [ meson ninja pkgconfig sphinx ];

  meta = with stdenv.lib; {
    description = "A minimalist command line interface to MPD";
    homepage = https://www.musicpd.org/clients/mpc/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ algorith ];
    platforms = with platforms; linux ++ darwin;
  };
}
