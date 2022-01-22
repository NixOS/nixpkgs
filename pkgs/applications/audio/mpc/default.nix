{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # fix the build with meson 0.60 (https://github.com/MusicPlayerDaemon/mpc/pull/76)
    (fetchpatch {
      url = "https://github.com/MusicPlayerDaemon/mpc/commit/b656ca4b6c2a0d5b6cebd7f7daa679352f664e0e.patch";
      sha256 = "sha256-fjjSlCKxgkz7Em08CaK7+JAzl8YTzLcpGGMz2HJlsVw=";
    })
  ];

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
