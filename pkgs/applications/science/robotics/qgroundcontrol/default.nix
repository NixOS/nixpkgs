{ stdenv, fetchgit, git,  SDL2, udev, doxygen
, qtbase, qtlocation, qtserialport, qtdeclarative, qtconnectivity, qtxmlpatterns
, qtsvg, qtquick1, qtquickcontrols, qtgraphicaleffects, qmake, qtspeech
, makeWrapper
, gst_all_1, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "qgroundcontrol";
  version = "3.3.0";

  qtInputs = [
    qtbase qtlocation qtserialport qtdeclarative qtconnectivity qtxmlpatterns qtsvg
    qtquick1 qtquickcontrols qtgraphicaleffects qtspeech
  ];

  gstInputs = with gst_all_1; [
    gstreamer gst-plugins-base
  ];

  enableParallelBuilding = true;
  buildInputs = [ SDL2 udev doxygen git ] ++ gstInputs ++ qtInputs;
  nativeBuildInputs = [ pkgconfig makeWrapper qmake ];

  preConfigure = ''
    mkdir build
    cd build
  '';

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
    rev = "refs/tags/v${version}";
    sha256 = "0abjm0wywp24qlgg9w8g35ijprjg5csq4fgba9caaiwvmpfbhmpw";
    fetchSubmodules = true;
  };

  meta = with stdenv.lib; {
    description = "Provides full ground station support and configuration for the PX4 and APM Flight Stacks";
    homepage = http://qgroundcontrol.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pxc ];
    broken = true;
  };
}
