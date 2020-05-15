{ lib, mkDerivation, fetchgit, SDL2
, qtbase, qtcharts, qtlocation, qtserialport, qtsvg, qtquickcontrols2
, qtgraphicaleffects, qtspeech, qmake
, makeWrapper
, gst_all_1, pkgconfig
}:

mkDerivation rec {
  pname = "qgroundcontrol";
  version = "3.5.5";

  qtInputs = [
    qtbase qtcharts qtlocation qtserialport qtsvg qtquickcontrols2
    qtgraphicaleffects qtspeech
  ];

  gstInputs = with gst_all_1; [
    gstreamer gst-plugins-base
  ];

  enableParallelBuilding = true;
  buildInputs = [ SDL2 ] ++ gstInputs ++ qtInputs;
  nativeBuildInputs = [ pkgconfig makeWrapper qmake ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  NIX_CFLAGS_COMPILE = [ "-Wno-address-of-packed-member" ]; # Don't litter logs with these warnings

  qmakeFlags = [
    # Default install tries to copy Qt files into package
    "CONFIG+=QGC_DISABLE_BUILD_SETUP"
    "../qgroundcontrol.pro"
  ];

  installPhase = ''
    cd ..

    mkdir -p $out/share/applications
    sed 's/Exec=.*$/Exec=QGroundControl/g' --in-place deploy/qgroundcontrol.desktop
    cp -v deploy/qgroundcontrol.desktop $out/share/applications

    mkdir -p $out/bin
    cp -v build/release/QGroundControl "$out/bin/"

    mkdir -p $out/share/qgroundcontrol
    cp -rv resources/ $out/share/qgroundcontrol

    mkdir -p $out/share/pixmaps
    cp -v resources/icons/qgroundcontrol.png $out/share/pixmaps
  '';

  postInstall = ''
    wrapProgram "$out/bin/qgroundcontrol" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
  '';

  # TODO: package mavlink so we can build from a normal source tarball
  src = fetchgit {
    url = "https://github.com/mavlink/qgroundcontrol.git";
    rev = "v${version}";
    sha256 = "05zy6w9lwwh254wa8c6wysa67kk0flywcvipii9b1rmy47slflhs";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "Provides full ground station support and configuration for the PX4 and APM Flight Stacks";
    homepage = "http://qgroundcontrol.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pxc ];
  };
}
