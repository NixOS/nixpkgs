{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoconf-archive
, autoreconfHook
, cmocka
, curl
, expat
, expect
, glib
, glibcLocales
, libmesode
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
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "profanity";
    rev = version;
    hash = "sha256-8WGHOy0fSW8o7vMCYZqqpvDsn81JZefM6wGfjQ5iKbU=";
  };

  patches = [
    ./patches/packages-osx.patch

    # pullupstream fixes for ncurses-6.3
    (fetchpatch {
      name = "ncurses-6.3-p1.patch";
      url = "https://github.com/profanity-im/profanity/commit/e5b6258c997d4faf36e2ffb8a47b386c5629b4eb.patch";
      sha256 = "sha256-4rwpvsgfIQ60GcLS0O7Hyn7ZidREjYT+dVND54z0zrw=";
    })
    (fetchpatch {
      name = "ncurses-6.3-p2.patch";
      url = "https://github.com/profanity-im/profanity/commit/fd9ccec8dc604902bbb1d444dba4223ccee0a092.patch";
      sha256 = "sha256-4gZaXoDNulBIR+e6y/9bJKXVactCHWS8H8lPJaJwVwE=";
    })
    (fetchpatch {
      name = "ncurses-6.3-p3.patch";
      url = "https://github.com/profanity-im/profanity/commit/242696f09a49c8446ba6aef8bdad65fb58a77715.patch";
      sha256 = "sha256-BOYHkae9aIA7HaVM23Yu25TTK9e3SuV+u0FEi7Sn62I=";
    })
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
    libmesode
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
