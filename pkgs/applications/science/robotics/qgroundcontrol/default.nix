{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  qtbase,
  qtcharts,
  qtlocation,
  qtserialport,
  qtsvg,
  qtquickcontrols2,
  qtgraphicaleffects,
  qtspeech,
  qtx11extras,
  qmake,
  qttools,
  gst_all_1,
  wayland,
  pkg-config,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "qgroundcontrol";
  version = "4.3.0";

  propagatedBuildInputs = [
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
  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
    wrapQtAppsHook
  ];

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
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-a0+cpT413qi88PvaWQPxKABHfK7vbPE7B42n84n/SAk=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "Provides full ground station support and configuration for the PX4 and APM Flight Stacks";
    homepage = "http://qgroundcontrol.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
    mainProgram = "QGroundControl";
  };
}
