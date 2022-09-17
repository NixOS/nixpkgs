{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, alsa-lib
, python3
, SDL
}:

stdenv.mkDerivation rec {
  pname = "schismtracker";
  version = "20220506";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-fK0FBn9e7l1Y/A7taFlaoas6ZPREFhEmskVBqjda6q0=";
  };

  configureFlags = [ "--enable-dependency-tracking" ]
    ++ lib.optional stdenv.isDarwin "--disable-sdltest";

  nativeBuildInputs = [ autoreconfHook python3 ];

  buildInputs = [ SDL ] ++ lib.optional stdenv.isLinux alsa-lib;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Music tracker application, free reimplementation of Impulse Tracker";
    homepage = "http://schismtracker.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ftrvxmtrx ];
  };
}
