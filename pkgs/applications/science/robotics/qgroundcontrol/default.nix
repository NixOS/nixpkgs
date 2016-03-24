{ stdenv, fetchurl, git,  espeak, SDL, udev, doxygen, cmake
  , qtbase, qtlocation, qtserialport, qtdeclarative, qtconnectivity, qtxmlpatterns
  , qtsvg, qtquick1, qtquickcontrols, qtgraphicaleffects
  , makeQtWrapper, lndir
  , gst_all_1, qt_gstreamer1, pkgconfig, glibc
  , version ? "2.9.4"
}:

stdenv.mkDerivation rec {
  inherit version;
  name = "qgroundcontrol-${version}";
  buildInputs = [
   SDL udev doxygen git glibc
  ] ++ gstInputs;

  qtInputs = [
#    qtbase qtlocation qtserialport qtdeclarative 
    qtbase qtlocation qtserialport qtdeclarative qtconnectivity qtxmlpatterns qtsvg 
    qtquick1 qtquickcontrols qtgraphicaleffects
  ];

  gstInputs = with gst_all_1; [
    gstreamer gst-plugins-base
  ];

  enableParallelBuilding = true;
  nativeBuildInputs = [
    pkgconfig makeQtWrapper
 ] ++ qtInputs;

  preConfigure = ''
    git submodule init
    git submodule update
  '';

  configurePhase = ''
    mkdir build
    pushd build

    qmake PREFIX=$out $src/qgroundcontrol.pro

    popd
  '';

  preBuild = "pushd build/";
  postBuild = "popd";

#  makefile = "build/Makefile";
 
  installPhase = ''
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

  src = fetchurl {
    url = "https://github.com/mavlink/qgroundcontrol/releases/download/v${version}/qgroundcontrol.tar.bz2";
    sha256 = "876328e9d15f643c97b9abf88949407a270ecd18365b2c5c495429fb05fc72cc";
  };

  meta = {
    description = "provides full ground station support and configuration for the PX4 and APM Flight Stacks";
    homepage = http://qgroundcontrol.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ pxc ];
  };
}
