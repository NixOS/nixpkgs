{ stdenv, fetchurl, fetchpatch
, ncurses, boehmgc, gettext, zlib
, sslSupport ? true, openssl ? null
, graphicsSupport ? true, imlib2 ? null
, x11Support ? graphicsSupport, libX11 ? null
, mouseSupport ? !stdenv.isDarwin, gpm-ncurses ? null
, perl, man
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

  NIX_LDFLAGS = optionalString stdenv.isSunOS "-lsocket -lnsl";

  # we must set these so that the generated files (e.g. w3mhelp.cgi) contain
  # the correct paths.
  PERL = "${perl}/bin/perl";
  MAN = "${man}/bin/man";

  # the Arch patches were pulled from:
  # https://aur.archlinux.org/cgit/aur.git/?h=w3m-mouse
  patches = [
    ./RAND_egd.libressl.patch
    (fetchpatch {
      name = "file_handle.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/file_handle.patch?h=w3m-mouse&id=5b5f0fbb59f674575e87dd368fed834641c35f03";
      sha256 = "0kkqm68ig9d658kf1iwa1dwcf651f6dy2j98gplcks1mn3bdlak4";
    })
    (fetchpatch {
      name = "form_unknown.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/form_unknown.patch?h=w3m-mouse&id=5b5f0fbb59f674575e87dd368fed834641c35f03";
      sha256 = "1mbfclid3bihb1xv7sxcahprn3slzd6ga8rjzlq4rbq80bl053fw";
    })
    (fetchpatch {
      name = "gc72.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/gc72.patch?h=w3m-mouse&id=5b5f0fbb59f674575e87dd368fed834641c35f03";
      sha256 = "1n6anaw17by0s6rn25bwkgj2mck7ffspizpwbijvx1ynk451459a";
    })
    (fetchpatch {
      name = "https.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/https.patch?h=w3m-mouse&id=5b5f0fbb59f674575e87dd368fed834641c35f03";
      sha256 = "08skvaha1hjyapsh8zw5dgfy433mw2hk7qy9yy9avn8rjqj7kjxk";
    })
    (fetchpatch {
      name = "perl.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/perl.patch?h=w3m-mouse&id=5b5f0fbb59f674575e87dd368fed834641c35f03";
      sha256 = "15cq7cwh0d2v64i8by44rgxw48156sgh872921hxrqdakr95p3gy";
    })
    (fetchpatch {
      name = "w3m_rgba.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/w3m_rgba.patch?h=w3m-mouse&id=5b5f0fbb59f674575e87dd368fed834641c35f03";
      sha256 = "1dhp1p6z621ayyl9zip9w35x2cxyhhj72jv5dvf0zp4rk6cjm781";
    })
  ] ++ optional (graphicsSupport && !x11Support) [ ./no-x11.patch ]
    ++ optional stdenv.isCygwin ./cygwin.patch;

  buildInputs = [ncurses boehmgc gettext zlib]
    ++ optional sslSupport openssl
    ++ optional mouseSupport gpm-ncurses
    ++ optional graphicsSupport imlib2
    ++ optional x11Support libX11;

  postInstall = optionalString graphicsSupport ''
    ln -s $out/libexec/w3m/w3mimgdisplay $out/bin
  '';

  configureFlags = "--with-ssl=${openssl} --with-gc=${boehmgc}"
    + optionalString graphicsSupport " --enable-image=${optionalString x11Support "x11,"}fb";

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
    maintainers = [ maintainers.mornfall maintainers.cstrahan ];
  };
}
