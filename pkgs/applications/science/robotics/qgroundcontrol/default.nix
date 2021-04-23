{ lib, mkDerivation, fetchFromGitHub, SDL2
, qtbase, qtcharts, qtlocation, qtserialport, qtsvg, qtquickcontrols2
, qtgraphicaleffects, qtspeech, qtx11extras, qmake, qttools
, gst_all_1, wayland, pkg-config
}:

mkDerivation rec {
  pname = "qgroundcontrol";
  version = "4.1.2";

  qtInputs = [
    qtbase qtcharts qtlocation qtserialport qtsvg qtquickcontrols2
    qtgraphicaleffects qtspeech qtx11extras
  ];

  gstInputs = with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad wayland
  ];

  enableParallelBuilding = true;
  buildInputs = [ SDL2 ] ++ gstInputs ++ qtInputs;
  nativeBuildInputs = [ pkg-config qmake qttools ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  qmakeFlags = [
    "CONFIG+=StableBuild"
    # Default install tries to copy Qt files into package
    "CONFIG+=QGC_DISABLE_BUILD_SETUP"
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
    sha256 = "16q0g9b1kyan3qhhp5mmfnrx9h8q7qn83baplbiprqjgpvkxfll4";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "Provides full ground station support and configuration for the PX4 and APM Flight Stacks";
    homepage = "http://qgroundcontrol.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
