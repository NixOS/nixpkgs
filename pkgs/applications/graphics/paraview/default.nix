{ fetchurl, stdenv, cmake, qt4 }:

stdenv.mkDerivation {
  name = "paraview-3.4.0";
  src = fetchurl {
    url = http://www.paraview.org/files/v3.4/paraview-3.4.0.tar.gz;
    sha256 = "27544f442e957e9aa60b32c674f2dcd84fffeecc9a40071ef6e305333413187d";
  };

  patches = [ ./include-qobject.patch ];

  # I added these flags to get all the rpaths right, which I guess they are
  # taken from the qt4 sources. Not very nice.
  cmakeFlags = "-DCMAKE_SHARED_LINKER_FLAGS=\"-Wl,-rpath,$out/lib/paraview-3.4\"" +
    " -DCMAKE_EXE_LINKER_FLAGS=\"-Wl,-rpath,$out/lib/paraview-3.4" +
    " -lpng12 -lSM -lICE -lXrender -lXrandr -lXcursor -lXinerama" +
    " -lXfixes -lfreetype -lfontconfig -lXext -lX11 -lssl -lXt -lz\"" +
    " -DCMAKE_SKIP_BUILD_RPATH=ON" +
    " -DCMAKE_BUILD_TYPE=Release" +
    " -DCMAKE_INSTALL_PREFIX=$out";

  dontUseCmakeConfigure = true;

  # I rewrote the configure phase to get the $out references evaluated in
  # cmakeFlags
  configurePhase = ''
    set -x
    mkdir -p build;
    cd build
    eval -- "cmake .. $cmakeFlags"
    set +x
    '';

  buildInputs = [ cmake qt4 ];

  meta = {
    homepage = "http://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

