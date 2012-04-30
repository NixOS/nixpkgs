{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutil, bison,
  xcbutilwm, libstartup_notification, libX11, pcre, libev, yajl, flex,
  libXcursor, coreutils, perl }:

stdenv.mkDerivation rec {
  name = "i3-4.2";

  src = fetchurl {
    url = "http://i3wm.org/downloads/${name}.tar.bz2";
    sha256 = "e02c832820e8922a44e744e555294f8580c2f8e218c5c1029e52f1bde048732b";
  };

  buildInputs = [ which pkgconfig libxcb xcbutilkeysyms xcbutil bison xcbutilwm
    libstartup_notification libX11 pcre libev yajl flex libXcursor perl ];

  prePatch = ''
    sed s,/usr/bin/env,${coreutils}/bin/env, -i generate-command-parser.pl
    sed s,/usr/bin/env,${coreutils}/bin/env, -i i3-migrate-config-to-v4
    sed s,/usr/bin/env,${coreutils}/bin/env, -i i3-wsbar
  '';

  makeFlags = "all";
  installFlags = "PREFIX=\${out}";

  meta = {
    description = "i3 is a tiling window manager";
    homepage = http://i3wm.org;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
  };

}
