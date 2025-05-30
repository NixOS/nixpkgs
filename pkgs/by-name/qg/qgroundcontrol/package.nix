{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cpm-cmake,
  geographiclib,
  ulog-cpp,
  ninja,
  SDL2,
  gst_all_1,
  wayland,
  pkg-config,
  qt6,
}:

# TODO:
#  * Upstream patch
stdenv.mkDerivation (finalAttrs: {
  pname = "qgroundcontrol";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "mavlink";
    repo = "qgroundcontrol";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-MNhW4/a/fEVtbp88KBYWl5XE7sleszhXBr8WZ5UOGxg=";
  };

  patches = [
    ./disable-bad-message.patch
  ];

  # Unvendor CPM
  postPatch = ''
    rm cmake/modules/CPM.cmake
    ln -s ${cpm-cmake}/share/cpm/CPM.cmake cmake/modules/CPM.cmake
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ] ++ (with qt6; [
    qttools
    wrapQtAppsHook
  ]);

  propagatedBuildInputs = with qt6; [
    qtbase
    qtcharts
    qtlocation
    qtserialport
    qtsvg
    qtspeech
    qtsensors
    qt5compat
  ];

  gstInputs = with gst_all_1; [
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override { qt6Support = true; })
    gst-plugins-bad
    gst-libav
    wayland
  ];

  buildInputs = [
    SDL2
    geographiclib
    ulog-cpp
  ] ++ finalAttrs.gstInputs ++ finalAttrs.propagatedBuildInputs;

  cmakeFlags = [
    "-DQGC_BUILD_STABLE=ON"
    # Override maximum version to always accept the packaged qr6
    "-DQGC_QT_MAXIMUM_VERSION=${qt6.qtbase.version}"
    # Default install tries to copy Qt files into package
    "-DQGC_DISABLE_BUILD_SETUP=ON"
    # Disables an /etc/group check that has false positives on nixos
    "-DQGC_DISABLE_ETC_GROUP_CHECKS=ON"
    # Tries to download x86_64-only prebuilt binaries
    "-DDISABLE_AIRMAP=ON"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/applications
    sed 's/Exec=.*/Exec=QGroundControl/' --in-place deploy/qgroundcontrol.desktop
    cp -v deploy/qgroundcontrol.desktop $out/share/applications

    mkdir -p $out/bin
    cp -v bin/QGroundControl $out/bin/

    mkdir -p $out/share/qgroundcontrol
    cp -rv resources/ $out/share/qgroundcontrol

    mkdir -p $out/share/pixmaps
    cp -v resources/icons/qgroundcontrol.png $out/share/pixmaps

    runHook postInstall
  '';

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    description = "Provides full ground station support and configuration for the PX4 and APM Flight Stacks";
    homepage = "https://qgroundcontrol.com/";
    changelog = "https://github.com/mavlink/qgroundcontrol/blob/master/ChangeLog.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lopsided98
      pandapip1
    ];
    mainProgram = "QGroundControl";
  };
})
