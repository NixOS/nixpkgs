{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libmpdclient
, sphinx
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "mpc";
  version = "0.34";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "mpc";
    rev    = "v${version}";
    sha256 = "sha256-2FjYBfak0IjibuU+CNQ0y9Ei8hTZhynS/BK2DNerhVw=";
  };

  buildInputs = [ libmpdclient ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  nativeBuildInputs = [ meson ninja pkg-config sphinx ];

  meta = with lib; {
    description = "A minimalist command line interface to MPD";
    homepage = "https://www.musicpd.org/clients/mpc/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ algorith ];
    platforms = with platforms; linux ++ darwin;
  };
}
