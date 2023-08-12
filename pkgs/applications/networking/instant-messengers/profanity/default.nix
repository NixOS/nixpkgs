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
, autoAwaySupport ? true,       libXScrnSaver, libX11
, notifySupport ? true,         libnotify, gdk-pixbuf
, omemoSupport ? true,          libsignal-protocol-c, libgcrypt
, pgpSupport ? true,            gpgme
, pythonPluginSupport ? true,   python3
, traySupport ? true,           gtk3
}:

stdenv.mkDerivation rec {
  pname = "profanity";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "profanity";
    rev = version;
    hash = "sha256-u/mp+vtMj602LfrulA+nhLNH8K6sqKIOuPJzhZusVmE=";
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
    ++ lib.optionals pythonPluginSupport [ python3 ]
    ++ lib.optionals traySupport         [ gtk3 ];

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
