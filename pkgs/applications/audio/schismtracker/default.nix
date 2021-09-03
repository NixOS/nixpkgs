{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, alsa-lib
, python
, SDL
}:

stdenv.mkDerivation rec {
  pname = "schismtracker";
  version = "20210525";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "06ybkbqry7f7lmzgwb9s7ipafshl5gdj98lcjsjkcbnywj8r9b3h";
  };

  configureFlags = [ "--enable-dependency-tracking" ]
    ++ lib.optional stdenv.isDarwin "--disable-sdltest";

  nativeBuildInputs = [ autoreconfHook python ];

  buildInputs = [ SDL ] ++ lib.optional stdenv.isLinux alsa-lib;

  meta = with lib; {
    description = "Music tracker application, free reimplementation of Impulse Tracker";
    homepage = "http://schismtracker.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ftrvxmtrx ];
  };
}
