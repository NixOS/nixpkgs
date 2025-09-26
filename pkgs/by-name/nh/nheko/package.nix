{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asciidoc,
  pkg-config,
  boost,
  cmark,
  coeurl,
  curl,
  kdsingleapplication,
  libevent,
  libsecret,
  lmdb,
  lmdbxx,
  mtxclient,
  nlohmann_json,
  olm,
  re2,
  spdlog,
  gst_all_1,
  libnice,
  qt6Packages,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "nheko";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "nheko";
    rev = "v${version}";
    hash = "sha256-WlWxe4utRSc9Tt2FsnhBwxzQsoDML2hvm3g5zRnDEiU=";
  };

  patches = [
    # Fixes rendering replies with QT 6.9.2
    (fetchpatch {
      url = "https://github.com/Nheko-Reborn/nheko/commit/2769642d3c7bd3c0d830b2f18ef6b3bf6a710bf4.patch";
      hash = "sha256-y8aiS6h5CSJYBdsAH4jYhAyrFug7aH2H8L6rBfULnQQ=";
    })
  ];

  nativeBuildInputs = [
    asciidoc
    cmake
    lmdbxx
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    cmark
    coeurl
    curl
    kdsingleapplication
    libevent
    libsecret
    lmdb
    mtxclient
    nlohmann_json
    olm
    qt6Packages.qtbase
    qt6Packages.qtimageformats
    qt6Packages.qtkeychain
    qt6Packages.qtmultimedia
    qt6Packages.qttools
    qt6Packages.qtwayland
    qt6Packages.qt-jdenticon
    re2
    spdlog
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override { qt6Support = true; })
    gst-plugins-bad
    libnice
  ]);

  cmakeFlags = [
    "-DCOMPILE_QML=ON" # see https://github.com/Nheko-Reborn/nheko/issues/389
  ];

  preFixup = ''
    # add gstreamer plugins path to the wrapper
    # unset QT_STYLE_OVERRIDE to avoid showing a blank window when started
    # https://github.com/NixOS/nixpkgs/issues/333009
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      --unset QT_STYLE_OVERRIDE
    )
  '';

  meta = with lib; {
    description = "Desktop client for the Matrix protocol";
    homepage = "https://github.com/Nheko-Reborn/nheko";
    license = licenses.gpl3Plus;
    mainProgram = "nheko";
    maintainers = with maintainers; [
      ekleog
      fpletz
      rnhmjoj
    ];
    platforms = platforms.all;
    # Should be fixable if a higher clang version is used, see:
    # https://github.com/NixOS/nixpkgs/pull/85922#issuecomment-619287177
    broken = stdenv.hostPlatform.isDarwin;
  };
}
