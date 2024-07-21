{ lib, stdenv, fetchFromGitHub, pkg-config, dbus-glib, autoreconfHook, xorg }:

stdenv.mkDerivation {
  pname = "kbdd";
  version = "unstable-2021-04-26";

  src = fetchFromGitHub {
    owner = "qnikst";
    repo = "kbdd";
    rev = "3145099e1fbbe65b27678be72465aaa5b5872874";
    sha256 = "1gzcjnflgdqnjgphiqpzwbcx60hm0h2cprncm7i8xca3ln5q6ba1";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ xorg.libX11 dbus-glib ];

  meta = {
    description = "Simple daemon and library to make per window layout using XKB";
    homepage = "https://github.com/qnikst/kbdd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "kbdd";
  };
}
