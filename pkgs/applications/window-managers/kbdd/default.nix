{ stdenv, fetchgit, pkgconfig, dbus_glib, autoreconfHook, xorg }:

stdenv.mkDerivation rec {
  name = "kbdd";

  src = fetchgit {
    url = https://github.com/qnikst/kbdd;
    rev = "47dee0232f157cd865e43d92005a2ba107f6fd75";
    sha256 = "1b9a66d216326a9759cad26393fbf8259fe7a0c2dd1075047fc989f0e52d969f";
  };

  buildInputs = [ pkgconfig xorg.libX11 dbus_glib autoreconfHook ];

  meta = {
    description = "Simple daemon and library to make per window layout using XKB";
    homepage = https://github.com/qnikst/kbdd;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.wedens ];
  };
}
