{ stdenv, fetchgit, pkgconfig, dbus-glib, autoreconfHook, xorg }:

stdenv.mkDerivation rec {
  name = "kbdd";

  src = fetchgit {
    url = https://github.com/qnikst/kbdd;
    rev = "47dee0232f157cd865e43d92005a2ba107f6fd75";
    sha256 = "1ys9w1lncsfg266g9sfnm95an2add3g51mryg0hnrzcqa4knz809";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ xorg.libX11 dbus-glib ];

  meta = {
    description = "Simple daemon and library to make per window layout using XKB";
    homepage = https://github.com/qnikst/kbdd;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.wedens ];
  };
}
