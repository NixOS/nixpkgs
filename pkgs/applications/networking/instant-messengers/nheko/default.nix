{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, asciidoc
, cmark
, lmdb
, lmdbxx
, libsecret
, mkDerivation
, qtbase
, qtkeychain
, qtmacextras
, qtmultimedia
, qtimageformats
, qttools
, qtquickcontrols2
, qtgraphicaleffects
, mtxclient
, boost17x
, spdlog
, olm
, pkg-config
, nlohmann_json
, coeurl
, libevent
, curl
, voipSupport ? true
, gst_all_1
, libnice
}:

mkDerivation rec {
  pname = "nheko";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "nheko";
    rev = "v${version}";
    sha256 = "sha256-roC1OIq0Vmj5rABNtH4IOMHX9aSlOMFC7ZHueuj/PmE=";
  };

  nativeBuildInputs = [
    lmdbxx
    cmake
    pkg-config
    asciidoc
  ];

  buildInputs = [
    nlohmann_json
    mtxclient
    olm
    boost17x
    libsecret
    lmdb
    spdlog
    cmark
    qtbase
    qtmultimedia
    qtimageformats
    qttools
    qtquickcontrols2
    qtgraphicaleffects
    qtkeychain
    coeurl
    libevent
    curl
  ] ++ lib.optional stdenv.isDarwin qtmacextras
    ++ lib.optionals voipSupport (with gst_all_1; [
      gstreamer
      gst-plugins-base
      (gst-plugins-good.override { qt5Support = true; })
      gst-plugins-bad
      libnice
    ]);

  cmakeFlags = [
    "-DCOMPILE_QML=ON" # see https://github.com/Nheko-Reborn/nheko/issues/389
  ];

  preFixup = lib.optionalString voipSupport ''
    # add gstreamer plugins path to the wrapper
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Desktop client for the Matrix protocol";
    homepage = "https://github.com/Nheko-Reborn/nheko";
    maintainers = with maintainers; [ ekleog fpletz ];
    platforms = platforms.all;
    # Should be fixable if a higher clang version is used, see:
    # https://github.com/NixOS/nixpkgs/pull/85922#issuecomment-619287177
    broken = stdenv.targetPlatform.isDarwin;
    license = licenses.gpl3Plus;
  };
}
