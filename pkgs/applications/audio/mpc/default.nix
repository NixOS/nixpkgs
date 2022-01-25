{ lib
, stdenv
, fetchFromGitHub
, libiconv
, libmpdclient
, meson
, ninja
, pkg-config
, sphinx
}:

stdenv.mkDerivation rec {
  pname = "mpc";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "mpc";
    rev = "v${version}";
    hash = "sha256-2FjYBfak0IjibuU+CNQ0y9Ei8hTZhynS/BK2DNerhVw=";
  };

  buildInputs = [
    libmpdclient
  ]
  ++ lib.optionals stdenv.isDarwin [ libiconv ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sphinx
  ];

  meta = with lib; {
    homepage = "https://www.musicpd.org/clients/mpc/";
    description = "A minimalist command line interface to MPD";
    license = licenses.gpl2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
