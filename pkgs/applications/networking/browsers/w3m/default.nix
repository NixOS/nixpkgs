{ stdenv, fetchurl
, ncurses, boehmgc, gettext, zlib
, sslSupport ? true, openssl ? null
, graphicsSupport ? true, imlib2 ? null
, x11Support ? graphicsSupport, libX11 ? null
, mouseSupport ? !stdenv.isDarwin, gpm-ncurses ? null
}:

assert sslSupport -> openssl != null;
assert graphicsSupport -> imlib2 != null;
assert x11Support -> graphicsSupport && libX11 != null;
assert mouseSupport -> gpm-ncurses != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "w3m-0.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/w3m/${name}.tar.gz";
    sha256 = "1qx9f0kprf92r1wxl3sacykla0g04qsi0idypzz24b7xy9ix5579";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isSunOS "-lsocket -lnsl";

  patches = [ ./glibc214.patch ]
    # Patch for the newer unstable boehm-gc 7.2alpha. Not all platforms use that
    # alpha. At the time of writing this, boehm-gc-7.1 is the last stable.
    ++ optional (boehmgc.name != "boehm-gc-7.1") [ ./newgc.patch ]
    ++ optional stdenv.isCygwin ./cygwin.patch
    # for frame buffer only version
    ++ optional (graphicsSupport && !x11Support) [ ./no-x11.patch ];

  buildInputs = [ncurses boehmgc gettext zlib]
    ++ optional sslSupport openssl
    ++ optional mouseSupport gpm-ncurses
    ++ optional graphicsSupport imlib2
    ++ optional x11Support libX11;

  configureFlags = "--with-ssl=${openssl} --with-gc=${boehmgc}"
    + optionalString graphicsSupport " --enable-image=${optionalString x11Support "x11,"}fb";

  preConfigure = ''
    substituteInPlace ./configure --replace "/lib /usr/lib /usr/local/lib /usr/ucblib /usr/ccslib /usr/ccs/lib /lib64 /usr/lib64" /no-such-path
    substituteInPlace ./configure --replace /usr /no-such-path
  '';

  enableParallelBuilding = false;

  # for w3mimgdisplay
  LIBS = optionalString x11Support "-lX11";

  meta = {
    homepage = http://w3m.sourceforge.net/;
    description = "A text-mode web browser";
    maintainers = [ maintainers.mornfall ];
  };
}
