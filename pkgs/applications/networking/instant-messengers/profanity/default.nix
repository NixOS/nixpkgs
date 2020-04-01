{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, openssl
, glibcLocales, expect, ncurses, libotr, curl, readline, libuuid
, cmocka, libmicrohttpd, stabber, expat, libmesode
, autoconf-archive

, autoAwaySupport ? true,       libXScrnSaver ? null, libX11 ? null
, notifySupport ? true,         libnotify ? null, gdk-pixbuf ? null
, traySupport ? true,           gnome2 ? null
, pgpSupport ? true,            gpgme ? null
, pythonPluginSupport ? true,   python ? null
, omemoSupport ? true,          libsignal-protocol-c ? null, libgcrypt ? null
}:

assert autoAwaySupport     -> libXScrnSaver != null && libX11 != null;
assert notifySupport       -> libnotify != null && gdk-pixbuf != null;
assert traySupport         -> gnome2 != null;
assert pgpSupport          -> gpgme != null;
assert pythonPluginSupport -> python != null;
assert omemoSupport        -> libsignal-protocol-c != null && libgcrypt != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "profanity";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "profanity";
    rev = version;
    sha256 = "0fg5xcdlvhsi7a40w4jcxyj7m7wl42jy1cvsa8fi2gb6g9y568k8";
  };

  patches = [ ./patches/packages-osx.patch ./patches/undefined-macros.patch ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook autoconf-archive glibcLocales pkgconfig
  ];

  buildInputs = [
    expect readline libuuid glib openssl expat ncurses libotr
    curl libmesode cmocka libmicrohttpd stabber
  ] ++ optionals autoAwaySupport     [ libXScrnSaver libX11 ]
    ++ optionals notifySupport       [ libnotify gdk-pixbuf ]
    ++ optionals traySupport         [ gnome2.gtk ]
    ++ optionals pgpSupport          [ gpgme ]
    ++ optionals pythonPluginSupport [ python ]
    ++ optionals omemoSupport        [ libsignal-protocol-c libgcrypt ];

  # Enable feature flags, so that build fail if libs are missing
  configureFlags = [ "--enable-c-plugins" "--enable-otr" ]
    ++ optionals notifySupport       [ "--enable-notifications" ]
    ++ optionals traySupport         [ "--enable-icons" ]
    ++ optionals pgpSupport          [ "--enable-pgp" ]
    ++ optionals pythonPluginSupport [ "--enable-python-plugins" ]
    ++ optionals omemoSupport        [ "--enable-omemo" ];

  preAutoreconf = ''
    mkdir m4
  '';

  doCheck = true;

  LC_ALL = "en_US.utf8";

  meta = {
    description = "A console based XMPP client";
    longDescription = ''
      Profanity is a console based XMPP client written in C using ncurses and
      libstrophe, inspired by Irssi.
    '';
    homepage = http://www.profanity.im/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
    updateWalker = true;
  };
}
