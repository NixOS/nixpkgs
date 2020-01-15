{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, mpd_clientlib }:

stdenv.mkDerivation rec {
  pname = "mpc";
  version = "0.28";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "mpc";
    rev    = "v${version}";
    sha256 = "1g8i4q5xsqdhidyjpvj6hzbhxacv27cb47ndv9k68whd80c5f9n9";
  };

  buildInputs = [ mpd_clientlib ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A minimalist command line interface to MPD";
    homepage = https://www.musicpd.org/clients/mpc/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ algorith ];
    platforms = with platforms; linux ++ darwin;
  };
}
