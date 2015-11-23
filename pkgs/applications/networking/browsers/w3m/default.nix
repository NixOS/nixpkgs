{ stdenv, fetchurl
, sslSupport ? true
, graphicsSupport ? false
, mouseSupport ? false
, ncurses, openssl ? null, boehmgc, gettext, zlib
, imlib2 ? null, xlibsWrapper ? null, fbcon ? null
, gpm-ncurses ? null
}:

assert sslSupport -> openssl != null;
assert graphicsSupport -> imlib2 != null && (xlibsWrapper != null || fbcon != null);
assert mouseSupport -> gpm-ncurses != null;

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
    ++ stdenv.lib.optional (boehmgc.name != "boehm-gc-7.1") [ ./newgc.patch ]
    ++ stdenv.lib.optional stdenv.isCygwin ./cygwin.patch;

  buildInputs = [ncurses boehmgc gettext zlib]
    ++ stdenv.lib.optional sslSupport openssl
    ++ stdenv.lib.optional mouseSupport gpm-ncurses
    ++ stdenv.lib.optionals graphicsSupport [imlib2 xlibsWrapper fbcon];

  configureFlags = "--with-ssl=${openssl} --with-gc=${boehmgc}"
    + stdenv.lib.optionalString graphicsSupport " --enable-image=x11,fb";

  preConfigure = ''
    substituteInPlace ./configure --replace "/lib /usr/lib /usr/local/lib /usr/ucblib /usr/ccslib /usr/ccs/lib /lib64 /usr/lib64" /no-such-path
    substituteInPlace ./configure --replace /usr /no-such-path
  '';

  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    homepage = http://w3m.sourceforge.net/;
    description = "A text-mode web browser";
    maintainers = [ maintainers.mornfall ];
  };
}
