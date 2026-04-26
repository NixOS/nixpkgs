{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  wrapQtAppsHook,
  qtbase,
  qtmultimedia,
  qtimageformats,
  qttools,
  libidn,
  qca,
  libxscrnsaver,
  hunspell,
  libsecret,
  libgcrypt,
  libgpg-error,
  usrsctp,
  qtkeychain,

  chatType ? "basic", # See the assertion below for available options
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

  # For tests
  psi-plus,
}:

assert lib.assertMsg (lib.toLower chatType != "webkit")
  "psi-plus: chatType = \"webkit\" was removed because qtwebkit had known vulns and has no Qt6 equivalent. Use chatType = \"webengine\" instead.";

assert builtins.elem (lib.toLower chatType) [
  "basic" # Basic implementation, no web stuff involved
  "webengine" # QtWebEngine (see https://wiki.qt.io/QtWebEngine)
];

assert enablePsiMedia -> enablePlugins;

stdenv.mkDerivation rec {
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
    "-DQT_DEFAULT_MAJOR_VERSION=6"
  ];

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ]
  ++ lib.optionals enablePsiMedia [
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qtimageformats
    libidn
    qca
    libxscrnsaver
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
  ++ lib.optionals (chatType == "webengine") [
    qtwebengine
  ];

  preFixup = lib.optionalString voiceMessagesSupport ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    )
  '';

  passthru.tests = {
    webengine = psi-plus.override { chatType = "webengine"; };
  };

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
