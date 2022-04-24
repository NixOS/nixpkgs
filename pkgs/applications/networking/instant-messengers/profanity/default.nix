{ lib
, stdenv
, fetchFromGitHub
, autoconf-archive
, autoreconfHook
, cmocka
, curl
, expat
, expect
, glib
, glibcLocales
, libstrophe
, libmicrohttpd
, libotr
, libuuid
, ncurses
, openssl
, pkg-config
, readline
, sqlite
, autoAwaySupport ? true,       libXScrnSaver ? null, libX11
, notifySupport ? true,         libnotify, gdk-pixbuf
, omemoSupport ? true,          libsignal-protocol-c, libgcrypt
, pgpSupport ? true,            gpgme
, pythonPluginSupport ? true,   python
, traySupport ? true,           gtk
}:

assert autoAwaySupport     -> libXScrnSaver != null && libX11 != null;
assert notifySupport       -> libnotify != null && gdk-pixbuf != null;
assert traySupport         -> gtk != null;
assert pgpSupport          -> gpgme != null;
assert pythonPluginSupport -> python != null;
assert omemoSupport        -> libsignal-protocol-c != null && libgcrypt != null;

stdenv.mkDerivation rec {
  pname = "profanity";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "profanity";
    rev = version;
    hash = "sha256-kmixWp9Q2tMVp+tk5kbTdBfgRNghKk3+48L582hqlm8=";
  };

  patches = [
    ./patches/packages-osx.patch
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    glibcLocales
    pkg-config
  ];

  buildInputs = [
    cmocka
    curl
    expat
    expect
    glib
    libstrophe
    libmicrohttpd
    libotr
    libuuid
    ncurses
    openssl
    readline
    sqlite
  ] ++ lib.optionals autoAwaySupport     [ libXScrnSaver libX11 ]
    ++ lib.optionals notifySupport       [ libnotify gdk-pixbuf ]
    ++ lib.optionals omemoSupport        [ libsignal-protocol-c libgcrypt ]
    ++ lib.optionals pgpSupport          [ gpgme ]
    ++ lib.optionals pythonPluginSupport [ python ]
    ++ lib.optionals traySupport         [ gtk ];

  # Enable feature flags, so that build fail if libs are missing
  configureFlags = [
    "--enable-c-plugins"
    "--enable-otr"
  ] ++ lib.optionals notifySupport       [ "--enable-notifications" ]
    ++ lib.optionals traySupport         [ "--enable-icons-and-clipboard" ]
    ++ lib.optionals pgpSupport          [ "--enable-pgp" ]
    ++ lib.optionals pythonPluginSupport [ "--enable-python-plugins" ]
    ++ lib.optionals omemoSupport        [ "--enable-omemo" ];

  preAutoreconf = ''
    mkdir m4
  '';

  doCheck = true;

  LC_ALL = "en_US.utf8";

  meta =  with lib; {
    homepage = "http://www.profanity.im/";
    description = "A console based XMPP client";
    longDescription = ''
      Profanity is a console based XMPP client written in C using ncurses and
      libstrophe, inspired by Irssi.
    '';
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.devhell ];
    platforms = platforms.unix;
  };
}
