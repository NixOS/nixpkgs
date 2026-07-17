{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  cmocka,
  curl,
  expat,
  expect,
  glib,
  glibcLocales,
  libstrophe,
  libmicrohttpd,
  libuuid,
  ncurses,
  openssl,
  pkg-config,
  readline,
  sqlite,
  autoAwaySupport ? true,
  libxscrnsaver,
  libx11,
  notifySupport ? true,
  libnotify,
  gdk-pixbuf,
  omemoSupport ? true,
  libsignal-protocol-c,
  libgcrypt,
  qrencode,
  pgpSupport ? true,
  gpgme,
  pythonPluginSupport ? true,
  python3,
  traySupport ? true,
  gtk3,
  otrSupport ? true,
  libotr,
  avatarScalingSupport ? true,
  spellcheckSupport ? true,
  enchant,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "profanity";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "profanity";
    rev = finalAttrs.version;
    hash = "sha256-rPiYzG5KvJyKt7b99AImmO6wTYxZPFcf/6Xhz8SrgIo=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    curl
    expat
    expect
    glib
    libstrophe
    libmicrohttpd
    libuuid
    ncurses
    openssl
    readline
    sqlite
  ]
  ++ lib.optionals autoAwaySupport [
    libxscrnsaver
    libx11
  ]
  ++ lib.optionals notifySupport [
    libnotify
    gdk-pixbuf
  ]
  ++ lib.optionals omemoSupport [
    libsignal-protocol-c
    libgcrypt
    qrencode
  ]
  ++ lib.optionals pgpSupport [ gpgme ]
  ++ lib.optionals pythonPluginSupport [ python3 ]
  ++ lib.optionals traySupport [ gtk3 ]
  ++ lib.optionals otrSupport [ libotr ]
  ++ lib.optionals spellcheckSupport [ enchant ]
  ++ lib.optionals avatarScalingSupport [ gdk-pixbuf ];

  # see also: https://profanity-im.github.io/guide/latest/build.html#expl
  mesonFlags = [
    (lib.mesonBool "tests" finalAttrs.doCheck)
    (lib.mesonEnable "notifications" notifySupport)
    (lib.mesonEnable "python-plugins" pythonPluginSupport)
    (lib.mesonEnable "c-plugins" true)
    (lib.mesonEnable "otr" otrSupport)
    (lib.mesonEnable "pgp" pgpSupport)
    (lib.mesonEnable "omemo" omemoSupport)
    (lib.mesonEnable "omemo-qrcode" omemoSupport)
    (lib.mesonEnable "icons-and-clipboard" traySupport)
    (lib.mesonEnable "gdk-pixbuf" avatarScalingSupport)
    (lib.mesonEnable "xscreensaver" autoAwaySupport)
    (lib.mesonEnable "spellcheck" spellcheckSupport)
  ];

  # this build directory is hard coded by the tests:
  # https://github.com/profanity-im/profanity/blob/c9033aae568d1a8f5435c566f31aa165718c7726/tests/functionaltests/proftest.c#L275
  mesonBuildDir = "build_run";

  doCheck = true;
  nativeCheckInputs = [
    cmocka

    # when stabber is found, functional tests are enabled which take a very long time
    # stabber
  ];

  meta = {
    homepage = "https://profanity-im.github.io";
    description = "Console based XMPP client";
    mainProgram = "profanity";
    longDescription = ''
      Profanity is a console based XMPP client written in C using ncurses and
      libstrophe, inspired by Irssi.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.devhell ];
    platforms = lib.platforms.unix;
  };
})
