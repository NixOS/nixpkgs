{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  qtbase,
  qtmultimedia,
  qtimageformats,
  qtx11extras,
  qttools,
  libidn,
  qca-qt5,
  libXScrnSaver,
  hunspell,
  libsecret,
  libgcrypt,
  libgpg-error,
  usrsctp,
  qtkeychain,

  chatType ? "basic", # See the assertion below for available options
  qtwebkit,
  qtwebengine,

  enablePlugins ? true,
  html-tidy,
  http-parser,
  libotr,
  libomemo-c,

  # Voice messages
  voiceMessagesSupport ? true,
  gst_all_1,
  enablePsiMedia ? false,
  pkg-config,
}:

assert builtins.elem (lib.toLower chatType) [
  "basic" # Basic implementation, no web stuff involved
  "webkit" # Legacy one, based on WebKit (see https://wiki.qt.io/Qt_WebKit)
  "webengine" # QtWebEngine (see https://wiki.qt.io/QtWebEngine)
];

assert enablePsiMedia -> enablePlugins;

mkDerivation rec {
  pname = "psi-plus";

  version = "1.5.2115";
  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = version;
    sha256 = "sha256-4is3ksl6IsYP1L0WhTT/56QUtR+EC1X6Lftre2BO6pM=";
  };

  cmakeFlags = [
    "-DCHAT_TYPE=${chatType}"
    "-DENABLE_PLUGINS=${if enablePlugins then "ON" else "OFF"}"
    "-DBUILD_PSIMEDIA=${if enablePsiMedia then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [
    cmake
    qttools
  ]
  ++ lib.optionals enablePsiMedia [
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
    libgpg-error
    usrsctp
    qtkeychain
  ]
  ++ lib.optionals voiceMessagesSupport [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ]
  ++ lib.optionals enablePlugins [
    html-tidy
    http-parser
    libotr
    libomemo-c
  ]
  ++ lib.optionals (chatType == "webkit") [
    qtwebkit
  ]
  ++ lib.optionals (chatType == "webengine") [
    qtwebengine
  ];

  preFixup = lib.optionalString voiceMessagesSupport ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    )
  '';

  meta = {
    homepage = "https://psi-plus.com";
    description = "XMPP (Jabber) client based on Qt5";
    mainProgram = "psi-plus";
    maintainers = with lib.maintainers; [
      unclechu
    ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
