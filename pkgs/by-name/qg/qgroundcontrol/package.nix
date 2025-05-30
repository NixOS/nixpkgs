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
  nix-update-script,
  qt6,
}:

# TODO:
#  * Upstream patch
stdenv.mkDerivation (finalAttrs: {
  pname = "qgroundcontrol";
  version = "5.1.5";

  src = fetchFromGitHub {
    owner = "mavlink";
    repo = "qgroundcontrol";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-dKIVxr+9UsGb8MHC7C04SThw9kiIsqYkSxO6kw0BF+0=";
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

    install -D resources/icons/qgroundcontrol.png -t $out/share/icons/hicolor/128x128/apps

    runHook postInstall
  '';

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  # Plain nix-update doesn't treat "-dev" as a prerelease marker, so it
  # happily "upgrades" past real releases to QGC's unreleased dev-branch
  # snapshot tags (e.g. v5.2.0-dev, which has no GitHub Release at all) -
  # restrict to clean vX.Y.Z tags only.
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  meta = {
    description = "Provides full ground station support and configuration for the PX4 and APM Flight Stacks";
    homepage = "https://qgroundcontrol.com/";
    changelog = "https://github.com/mavlink/qgroundcontrol/blob/master/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lopsided98
      pandapip1
    ];
    mainProgram = "QGroundControl";
  };
})
