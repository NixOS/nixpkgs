{ stdenv, fetchgit, git,  espeak, SDL, udev, doxygen, cmake
  , qtbase, qtlocation, qtserialport, qtdeclarative, qtconnectivity, qtxmlpatterns
  , qtsvg, qtquick1, qtquickcontrols, qtgraphicaleffects, qmakeHook
  , makeQtWrapper, lndir
  , gst_all_1, qt-gstreamer1, pkgconfig, glibc
  , version ? "2.9.4"
}:

stdenv.mkDerivation rec {
  name = "qgroundcontrol-${version}";
  buildInputs = [
   SDL udev doxygen git
  ] ++ gstInputs;

  qtInputs = [
    qtbase qtlocation qtserialport qtdeclarative qtconnectivity qtxmlpatterns qtsvg 
    qtquick1 qtquickcontrols qtgraphicaleffects
  ];

  gstInputs = with gst_all_1; [
    gstreamer gst-plugins-base
  ];

  enableParallelBuilding = true;
  nativeBuildInputs = [
    pkgconfig makeQtWrapper qmakeHook
 ] ++ qtInputs;

  patches = [ ./0001-fix-gcc-cmath-namespace-issues.patch ];
  postPatch = ''
    sed '1i#include <cmath>' -i src/Vehicle/Vehicle.cc \
      -i src/comm/{QGCFlightGearLink,QGCJSBSimLink}.cc \
      -i src/{uas/UAS,ui/QGCDataPlot2D}.cc
  '';

  preConfigure = ''
    mkdir build
    cd build
  '';

  qmakeFlags = [ "../qgroundcontrol.pro" ];

  installPhase = ''
    cd ..
    mkdir -p $out/share/applications
    cp -v qgroundcontrol.desktop $out/share/applications
    
    mkdir -p $out/bin
    cp -v build/release/qgroundcontrol "$out/bin/"
    
    mkdir -p $out/share/qgroundcontrol
    cp -rv resources/ $out/share/qgroundcontrol
    
    mkdir -p $out/share/pixmaps
    cp -v resources/icons/qgroundcontrol.png $out/share/pixmaps

    # we need to link to our Qt deps in our own output if we want
    # this package to work without being installed as a system pkg
    mkdir -p $out/lib/qt5 $out/etc/xdg
    for pkg in $qtInputs; do
      if [[ -d $pkg/lib/qt5 ]]; then
        for dir in lib/qt5 share etc/xdg; do
          if [[ -d $pkg/$dir ]]; then
            ${lndir}/bin/lndir "$pkg/$dir" "$out/$dir"
          fi
        done
      fi
    done
  '';


  postInstall = ''
    wrapQtProgram "$out/bin/qgroundcontrol" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
  '';
  

  # TODO: package mavlink so we can build from a normal source tarball
  src = fetchgit {
    url = "https://github.com/mavlink/qgroundcontrol.git";
    rev = "refs/tags/v${version}";
    sha256 = "0isr0zamhvr853c94lblazkilil6zzmvf7afs3mxgn07jn9wrqz3";
    fetchSubmodules = true;
  };

  meta = {
    description = "Provides full ground station support and configuration for the PX4 and APM Flight Stacks";
    homepage = http://qgroundcontrol.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ pxc ];
    broken = true; # relies improperly on private Qt 5.5 headers
  };
}
