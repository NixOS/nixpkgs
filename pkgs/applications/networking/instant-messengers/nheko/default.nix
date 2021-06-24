{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, cmark
, lmdb
, lmdbxx
, libsecret
, tweeny
, mkDerivation
, qtbase
, qtkeychain
, qtmacextras
, qtmultimedia
, qttools
, qtquickcontrols2
, qtgraphicaleffects
, mtxclient
, boost17x
, spdlog
, fmt
, olm
, pkg-config
, nlohmann_json
, voipSupport ? true
, gst_all_1
, libnice
}:

mkDerivation rec {
  pname = "nheko";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "nheko";
    rev = "v${version}";
    sha256 = "1v7k3ifzi05fdr06hmws1wkfl1bmhrnam3dbwahp086vkj0r8524";
  };

  nativeBuildInputs = [
    lmdbxx
    cmake
    pkg-config
  ];

  buildInputs = [
    nlohmann_json
    tweeny
    mtxclient
    olm
    boost17x
    libsecret
    lmdb
    spdlog
    fmt
    cmark
    qtbase
    qtmultimedia
    qttools
    qtquickcontrols2
    qtgraphicaleffects
    qtkeychain
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
