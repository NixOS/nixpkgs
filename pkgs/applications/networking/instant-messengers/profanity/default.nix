{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, openssl
, glibcLocales, expect, ncurses, libotr, curl, readline, libuuid
, cmocka, libmicrohttpd, expat, sqlite, libmesode, fetchpatch
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
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "profanity";
    rev = version;
    sha256 = "14vbblf639f90bb4npg2xv53cpvk9am9ic4pmc1vnv4m3zsndjg5";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/profanity-im/profanity/commit/54667c022f17bdb547c3b8b4eec1c2889c9d60f3.patch";
      sha256 = "0aqrq45im1qnq308hyhh7dqbggzmcqb0b868wr5v8v08pd94s45k";
    })
    ./patches/packages-osx.patch
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook autoconf-archive glibcLocales pkgconfig
  ];

  buildInputs = [
    expect readline libuuid glib openssl expat ncurses libotr
    curl libmesode cmocka libmicrohttpd sqlite
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
    homepage = "http://www.profanity.im/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
    updateWalker = true;
  };
}
