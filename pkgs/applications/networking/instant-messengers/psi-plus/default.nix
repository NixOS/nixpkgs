{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qtmultimedia
, qtx11extras
, qttools
, libidn
, qca-qt5
, libXScrnSaver
, hunspell
, libsecret
, libgcrypt
, libotr
, html-tidy
, libgpg-error
, libsignal-protocol-c
, usrsctp

, chatType ? "basic" # See the assertion below for available options
, qtwebkit
, qtwebengine

, enablePlugins ? true

  # Voice messages
, voiceMessagesSupport ? true
, gst_all_1

, enablePsiMedia ? false
, pkg-config
}:

assert builtins.elem (lib.toLower chatType) [
  "basic" # Basic implementation, no web stuff involved
  "webkit" # Legacy one, based on WebKit (see https://wiki.qt.io/Qt_WebKit)
  "webengine" # QtWebEngine (see https://wiki.qt.io/QtWebEngine)
];

assert enablePsiMedia -> enablePlugins;

mkDerivation {
  pname = "psi-plus";

  # Version mask is “X.X.XXXX-R” where “X.X.XXXX” is a mandatory version of Psi
  # and “-R” ending is optional revision number.
  #
  # The “psi-plus-snapshots” generally provides snapshots of these separate
  # repositories glued together (there are also dependencies/libraries):
  #
  # 1. Psi
  # 2. Plugins pack for Psi
  # 3. “psimedia” plugin
  # 4. Resources for Psi (icons, skins, sounds)
  #
  # “X.X.XXXX” is literally a version of Psi.
  # So often when for instance plugins are updated separately a new snapshot is
  # created. And that snapshot would also be linked to “X.X.XXXX” version.
  # So many commits may have the same associated version of the snapshot.
  # But mind that only one Git tag is created for “X.X.XXXX” version.
  #
  # It’s not yet defined in the Psi+ project what value to use as a version for
  # any further releases that don’t change Psi version.
  #
  # Let’s do what Debian does for instance (appends “-R” where “R” is a revision
  # number).
  # E.g. https://tracker.debian.org/news/1226321/psi-plus-14554-5-migrated-to-testing/
  #
  # This has been communicated with the Psi+ main devs in this XMPP MUC chat:
  # psi-dev@conference.jabber.ru
  #
  version = "1.5.1556-2";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = "635879010b6697f7041a7bbea1853a1f4673c7f7";
    sha256 = "18xvljcm0a9swkyz4diwxi4xaj0w27jnhfgpi8fv5fj11j0g1b3a";
  };

  cmakeFlags = [
    "-DCHAT_TYPE=${chatType}"
    "-DENABLE_PLUGINS=${if enablePlugins then "ON" else "OFF"}"
    "-DBUILD_PSIMEDIA=${if enablePsiMedia then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [
    cmake
    qttools
  ] ++ lib.optionals enablePsiMedia [
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qtx11extras
    libidn
    qca-qt5
    libXScrnSaver
    hunspell
    libsecret
    libgcrypt
    libotr
    html-tidy
    libgpg-error
    libsignal-protocol-c
    usrsctp
  ] ++ lib.optionals voiceMessagesSupport [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ] ++ lib.optionals (chatType == "webkit") [
    qtwebkit
  ] ++ lib.optionals (chatType == "webengine") [
    qtwebengine
  ];

  preFixup = lib.optionalString voiceMessagesSupport ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    )
  '';

  meta = with lib; {
    homepage = "https://psi-plus.com";
    description = "XMPP (Jabber) client based on Qt5";
    maintainers = with maintainers; [ orivej misuzu unclechu ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
