{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qtmultimedia
, qtimageformats
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

mkDerivation rec {
  pname = "psi-plus";
  version = "1.5.1653";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = version;
    sha256 = "sha256-9WT2S6ZgIsrHoEAvlWUB078gzCdrPylvSjkkogU5tsU=";
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
    qtimageformats
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
    mainProgram = "psi-plus";
    maintainers = with maintainers; [ orivej unclechu ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
