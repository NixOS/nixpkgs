{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  qt6Packages,
  # nativeBuildInputs
  pkg-config,
  cmake,
  extra-cmake-modules,
  # buildInputs
  sqlite,
  libsecret,
  libre-graph-api-cpp-qt-client,
  kdsingleapplication,
  ## darwin only
  libinotify-kqueue,
}:

stdenv.mkDerivation rec {
  pname = "owncloud-client";
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "client";
    tag = "v${version}";
    hash = "sha256-HEnjtedmdNJTpc/PmEyoEsLGUydFkVF3UAsSdzQ4L1Q=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    sqlite
    libsecret
    qt6Packages.qtbase
    qt6Packages.qtsvg # Needed for the systray icon
    qt6Packages.qtkeychain
    libre-graph-api-cpp-qt-client
    kdsingleapplication
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libinotify-kqueue
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Synchronise your ownCloud with your computer using this desktop client";
    homepage = "https://owncloud.org";
    maintainers = with lib.maintainers; [
      qknight
      hellwolf
    ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    changelog = "https://github.com/owncloud/client/releases/tag/v${version}";
  };
}
