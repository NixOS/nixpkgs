{ stdenv, fetchurl, cmake, pkgconfig, boost, protobuf, freeimage
  , boost-build, boost_process
  , xorg_sys_opengl, tbb, ogre, tinyxml-2
  , libtar, glxinfo,  libusb-compat-0_1, libxslt, ignition
  , pythonPackages, utillinux

  # these deps are hidden; cmake doesn't catch them
  , gazeboSimulator, sdformat ? gazeboSimulator.sdformat, curl, tinyxml, qt4
  , xlibsWrapper
  , withIgnitionTransport ? true
  , libav, withLibAvSupport ? true
  , openal, withAudioSupport ? false
  , withQuickBuild ? false, withHeadless ? false, withLowMemorySupport ? false
  , doxygen, withDocs ? true
  , bullet, withBulletEngineSupport ? false
  , graphviz, withModelEditorSchematicView ? true # graphviz needed for this view
  , gdal, withDigitalElevationTerrainsSupport ? true
  , gts, withConstructiveSolidGeometrySupport ? true
  , hdf5, withHdf5Support ? true
  , version ? "7.0.0"
  , src-sha256 ? "127q2g93kvmak2b6vhl13xzg56h09v14s4pki8wv7aqjv0c3whbl"
  , ...
}: with stdenv.lib;

stdenv.mkDerivation rec {
  inherit version;
  pname = "gazebo";

  src = fetchurl {
    url = "https://osrf-distributions.s3.amazonaws.com/gazebo/releases/${pname}-${version}.tar.bz2";
    sha256 = src-sha256;
  };

  enableParallelBuilding = true; # gazebo needs this so bad
  cmakeFlags = [
  "-DCMAKE_INSTALL_LIBDIR:PATH=lib"
  "-DCMAKE_INSTALL_INCLUDEDIR=include" ]
    ++ optional withQuickBuild [ "-DENABLE_TESTS_COMPILATION=False" ]
    ++ optional withLowMemorySupport [ "-DUSE_LOW_MEMORY_TESTS=True" ]
    ++ optional withHeadless [ "-DENABLE_SCREEN_TESTS=False" ];

  nativeBuildInputs = [ cmake pkgconfig ];

  propagatedNativeBuildInputs = [ boost boost-build boost_process protobuf ];

  buildInputs = [
    #cmake boost protobuf
    freeimage
    xorg_sys_opengl
    tbb
    ogre
    tinyxml-2
    libtar
    glxinfo
    libusb-compat-0_1
    libxslt
    ignition.math2
    sdformat
    pythonPackages.pyopengl

    # TODO: add these hidden deps to cmake configuration & submit upstream
    curl
    tinyxml
    xlibsWrapper
    qt4
  ] ++ optional stdenv.isLinux utillinux # on Linux needs uuid/uuid.h
    ++ optional withDocs doxygen
    ++ optional withLibAvSupport libav  #TODO: package rubygem-ronn and put it here
    ++ optional withAudioSupport openal
    ++ optional withBulletEngineSupport bullet
    ++ optional withIgnitionTransport ignition.transport
    ++ optional withModelEditorSchematicView graphviz
    ++ optional withDigitalElevationTerrainsSupport gdal
    ++ optional withConstructiveSolidGeometrySupport gts
    ++ optional withHdf5Support hdf5;

  meta = with stdenv.lib; {
    homepage = "http://gazebosim.org/";
    description = "Multi-robot simulator for outdoor environments";
    license = licenses.asl20;
    maintainers = with maintainers; [ pxc ];
    platforms = platforms.all;
  };
}
