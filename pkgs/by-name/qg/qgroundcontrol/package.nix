{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libsForQt5,
  gst_all_1,
  wayland,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "qgroundcontrol";
  version = "4.4.2";

  propagatedBuildInputs = with libsForQt5; [
    qtbase
    qtcharts
    qtlocation
    qtserialport
    qtsvg
    qtquickcontrols2
    qtgraphicaleffects
    qtspeech
    qtx11extras
  ];

  gstInputs = with gst_all_1; [
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override { qt5Support = true; })
    gst-plugins-bad
    gst-libav
    wayland
  ];

  buildInputs = [ SDL2 ] ++ gstInputs ++ propagatedBuildInputs;
  nativeBuildInputs =
    [ pkg-config ]
    ++ (with libsForQt5; [
      qmake
      qttools
      wrapQtAppsHook
    ]);

  preConfigure = ''
    mkdir build
    cd build
  '';

  qmakeFlags = [
    "CONFIG+=StableBuild"
    # Default install tries to copy Qt files into package
    "CONFIG+=QGC_DISABLE_BUILD_SETUP"
    # Tries to download x86_64-only prebuilt binaries
    "DEFINES+=DISABLE_AIRMAP"
    "../qgroundcontrol.pro"
  ];

  installPhase = ''
    runHook preInstall

    cd ..

    mkdir -p $out/share/applications
    sed 's/Exec=.*$/Exec=QGroundControl/g' --in-place deploy/qgroundcontrol.desktop
    cp -v deploy/qgroundcontrol.desktop $out/share/applications

    mkdir -p $out/bin
    cp -v build/staging/QGroundControl "$out/bin/"

    mkdir -p $out/share/qgroundcontrol
    cp -rv resources/ $out/share/qgroundcontrol

    mkdir -p $out/share/pixmaps
    cp -v resources/icons/qgroundcontrol.png $out/share/pixmaps

    runHook postInstall
  '';

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  # TODO: package mavlink so we can build from a normal source tarball
  src = fetchFromGitHub {
    owner = "mavlink";
    repo = "qgroundcontrol";
    rev = "v${version}";
    hash = "sha256-2Bc4uC/2e+PTsvFZ4RjnTzkOiBO9vsYHeLPkcwpDRrg=";
    fetchSubmodules = true;
  };

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
}
