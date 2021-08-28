{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, glib, openssl
, glibcLocales, expect, ncurses, libotr, curl, readline, libuuid
, cmocka, libmicrohttpd, expat, sqlite, libmesode, autoconf-archive

, autoAwaySupport ? true,       libXScrnSaver ? null, libX11 ? null
, notifySupport ? true,         libnotify ? null, gdk-pixbuf ? null
, traySupport ? true,           gtk2 ? null
, pgpSupport ? true,            gpgme ? null
, pythonPluginSupport ? true,   python ? null
, omemoSupport ? true,          libsignal-protocol-c ? null, libgcrypt ? null
}:

assert autoAwaySupport     -> libXScrnSaver != null && libX11 != null;
assert notifySupport       -> libnotify != null && gdk-pixbuf != null;
assert traySupport         -> gtk2 != null;
assert pgpSupport          -> gpgme != null;
assert pythonPluginSupport -> python != null;
assert omemoSupport        -> libsignal-protocol-c != null && libgcrypt != null;

with lib;

stdenv.mkDerivation rec {
  pname = "profanity";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "profanity";
    rev = version;
    sha256 = "0a9rzhnivxcr8v02xxzrbck7pvvv4c66ap2zy0gzxhri5p8ac03r";
  };

  patches = [
    ./patches/packages-osx.patch
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook autoconf-archive glibcLocales pkg-config
  ];

  buildInputs = [
    expect readline libuuid glib openssl expat ncurses libotr
    curl libmesode cmocka libmicrohttpd sqlite
  ] ++ optionals autoAwaySupport     [ libXScrnSaver libX11 ]
    ++ optionals notifySupport       [ libnotify gdk-pixbuf ]
    ++ optionals traySupport         [ gtk2 ]
    ++ optionals pgpSupport          [ gpgme ]
    ++ optionals pythonPluginSupport [ python ]
    ++ optionals omemoSupport        [ libsignal-protocol-c libgcrypt ];

  # Enable feature flags, so that build fail if libs are missing
  configureFlags = [ "--enable-c-plugins" "--enable-otr" ]
    ++ optionals notifySupport       [ "--enable-notifications" ]
    ++ optionals traySupport         [ "--enable-icons-and-clipboard" ]
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
    changelog = "https://github.com/profanity-im/profanity/releases/tag/${version}";
    downloadPage = "https://github.com/profanity-im/profanity/releases/";
    maintainers = [ maintainers.devhell ];
    updateWalker = true;
  };
}
