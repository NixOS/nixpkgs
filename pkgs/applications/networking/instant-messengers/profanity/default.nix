{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, openssl
, glibcLocales, expect, ncurses, libotr, curl, readline, libuuid
, cmocka, libmicrohttpd, stabber, expat, libmesode

, autoAwaySupport ? false,       libXScrnSaver ? null, libX11 ? null
, notifySupport ? false,         libnotify ? null, gdk_pixbuf ? null
, traySupport ? false,           gnome2 ? null
, pgpSupport ? true,            gpgme ? null
, pythonPluginSupport ? true,   python ? null
}:

assert autoAwaySupport     -> libXScrnSaver != null && libX11 != null;
assert notifySupport       -> libnotify != null && gdk_pixbuf != null;
assert traySupport         -> gnome2 != null;
assert pgpSupport          -> gpgme != null;
assert pythonPluginSupport -> python != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "profanity-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "boothj5";
    repo = "profanity";
    rev = "${version}";
    sha256 = "1ppr02wivhlrqr62r901clnycna8zpn6kr7n5rw8y3zfw21ny17z";
  };

  patches = [ ./patches/packages-osx.patch ./patches/undefined-macros.patch ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook glibcLocales pkgconfig ];

  buildInputs = [
    expect readline libuuid glib openssl expat ncurses libotr
    curl libmesode cmocka libmicrohttpd stabber
  ] ++ optionals autoAwaySupport     [ libXScrnSaver libX11 ]
    ++ optionals notifySupport       [ libnotify gdk_pixbuf ]
    ++ optionals traySupport         [ gnome2.gtk ]
    ++ optionals pgpSupport          [ gpgme ]
    ++ optionals pythonPluginSupport [ python ];

  # Enable feature flags, so that build fail if libs are missing
  configureFlags = [ "--enable-c-plugins" "--enable-otr" ]
    ++ optionals notifySupport       [ "--enable-notifications" ]
    ++ optionals traySupport         [ "--enable-icons" ]
    ++ optionals pgpSupport          [ "--enable-pgp" ]
    ++ optionals pythonPluginSupport [ "--enable-python-plugins" ];

  preAutoreconf = ''
    mkdir m4
  '';

  doCheck = true;

  LC_ALL = "en_US.utf8";

  NIX_CFLAGS_COMPILE = [ ]
    ++ optionals pythonPluginSupport [ "-I${python}/include/${python.libPrefix}" ];

  LDFLAGS = [ ]
    ++ optionals pythonPluginSupport [ "-L${python}/lib" "-l${python.libPrefix}" ];

  meta = {
    description = "A console based XMPP client";
    longDescription = ''
      Profanity is a console based XMPP client written in C using ncurses and
      libstrophe, inspired by Irssi.
    '';
    homepage = http://profanity.im/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
    updateWalker = true;
  };
}
