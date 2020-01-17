{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, mpd_clientlib, sphinx, libiconv }:

stdenv.mkDerivation rec {
  pname = "mpc";
  version = "0.33";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "mpc";
    rev    = "v${version}";
    sha256 = "1qbi0i9cq54rj8z2kapk8x8g1jkw2jz781niwb9i7kw4xfhvy5zx";
  };

  buildInputs = [ mpd_clientlib ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  nativeBuildInputs = [ meson ninja pkgconfig sphinx ];

  meta = with stdenv.lib; {
    description = "A minimalist command line interface to MPD";
    homepage = https://www.musicpd.org/clients/mpc/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ algorith ];
    platforms = with platforms; linux ++ darwin;
  };
}
