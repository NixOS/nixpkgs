{ stdenv, fetchFromGitHub, fetchpatch
, ncurses, boehmgc, gettext, zlib
, sslSupport ? true, openssl ? null
, graphicsSupport ? !stdenv.isDarwin, imlib2 ? null
, x11Support ? graphicsSupport, libX11 ? null
, mouseSupport ? !stdenv.isDarwin, gpm-ncurses ? null
, perl, man, pkgconfig, buildPackages, w3m
}:

assert sslSupport -> openssl != null;
assert graphicsSupport -> imlib2 != null;
assert x11Support -> graphicsSupport && libX11 != null;
assert mouseSupport -> gpm-ncurses != null;

with stdenv.lib;

let
  mktable = buildPackages.stdenv.mkDerivation rec {
    name = "w3m-mktable";
    inherit (w3m) src;
    nativeBuildInputs = [ pkgconfig boehmgc ];
    makeFlags = [ "mktable" ];
    installPhase = ''
      install -D mktable $out/bin/mktable
    '';
  };
in stdenv.mkDerivation rec {
  name = "w3m-0.5.3+git20180125";

  src = fetchFromGitHub {
    owner = "tats";
    repo = "w3m";
    rev = "v0.5.3+git20180125";
    sha256 = "0dafdfx1yhrvhbqzslkcapj09dvf64m2jadz3wl2icni0k4msq90";
  };

  NIX_LDFLAGS = optionalString stdenv.isSunOS "-lsocket -lnsl";

  # we must set these so that the generated files (e.g. w3mhelp.cgi) contain
  # the correct paths.
  PERL = "${perl}/bin/perl";
  MAN = "${man}/bin/man";

  makeFlags = [ "AR=${stdenv.cc.bintools.targetPrefix}ar" ];

  patches = [
    ./RAND_egd.libressl.patch
    (fetchpatch {
      name = "https.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/https.patch?h=w3m-mouse&id=5b5f0fbb59f674575e87dd368fed834641c35f03";
      sha256 = "08skvaha1hjyapsh8zw5dgfy433mw2hk7qy9yy9avn8rjqj7kjxk";
    })
  ] ++ optional (graphicsSupport && !x11Support) [ ./no-x11.patch ];

  postPatch = optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    ln -s ${mktable}/bin/mktable mktable
    # stop make from recompiling mktable
    sed -ie 's!mktable.*:.*!mktable:!' Makefile.in
  '';

  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [ ncurses boehmgc zlib ]
    ++ optional sslSupport openssl
    ++ optional mouseSupport gpm-ncurses
    ++ optional graphicsSupport imlib2
    ++ optional x11Support libX11;

  postInstall = optionalString graphicsSupport ''
    ln -s $out/libexec/w3m/w3mimgdisplay $out/bin
  '';

  hardeningDisable = [ "format" ];

  configureFlags =
    [ "--with-ssl=${openssl.dev}" "--with-gc=${boehmgc.dev}" ]
    ++ optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      "ac_cv_func_setpgrp_void=yes"
    ]
    ++ optional graphicsSupport "--enable-image=${optionalString x11Support "x11,"}fb";

  preConfigure = ''
    substituteInPlace ./configure --replace "/lib /usr/lib /usr/local/lib /usr/ucblib /usr/ccslib /usr/ccs/lib /lib64 /usr/lib64" /no-such-path
    substituteInPlace ./configure --replace /usr /no-such-path
  '';

  enableParallelBuilding = false;

  # for w3mimgdisplay
  # see: https://bbs.archlinux.org/viewtopic.php?id=196093
  LIBS = optionalString x11Support "-lX11";

  meta = {
    homepage = http://w3m.sourceforge.net/;
    description = "A text-mode web browser";
    maintainers = [ maintainers.cstrahan ];
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.mit;
  };
}
