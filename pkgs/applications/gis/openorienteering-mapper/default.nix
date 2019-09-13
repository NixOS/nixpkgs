{ stdenv, fetchFromGitHub, gdal, cmake, ninja, proj, clipper, zlib, qtbase, qttools
, qtlocation, qtsensors, doxygen, cups, wrapQtAppsHook, qtimageformats
}:

stdenv.mkDerivation rec {
  pname = "OpenOrienteering-Mapper";
  version = "0.8.4";

  buildInputs = [ gdal qtbase qttools qtlocation qtimageformats
                  qtsensors clipper zlib proj doxygen cups];

  nativeBuildInputs = [ cmake wrapQtAppsHook ninja ];

  src = fetchFromGitHub {
    owner = "OpenOrienteering";
    repo = "mapper";
    rev = "v${version}";
    sha256 = "0rw34kp2vd1la97vnk9plwvis6lvyib2bvs7lgkhpnm4p5l7dp1g";
  };

  cmakeFlags =
    [
    # Building the manual and bundling licenses fails
    "-DLICENSING_PROVIDER:BOOL=OFF"
    "-DMapper_MANUAL_QTHELP:BOOL=OFF"
    ] ++
    (stdenv.lib.optionals stdenv.isDarwin
    [
    # Usually enabled on Darwin
    "-DCMAKE_FIND_FRAMEWORK=never"
    # FindGDAL is broken and always finds /Library/Framework unless this is
    # specified
    "-DGDAL_INCLUDE_DIR=${gdal}/include"
    "-DGDAL_CONFIG=${gdal}/bin/gdal-config"
    "-DGDAL_LIBRARY=${gdal}/lib/libgdal.dylib"
    # Don't bundle libraries
    "-DMapper_PACKAGE_PROJ=0"
    "-DMapper_PACKAGE_QT=0"
    "-DMapper_PACKAGE_ASSISTANT=0"
    "-DMapper_PACKAGE_GDAL=0"
    ]);

  # Needs to be available when proj_api.h gets evaluted by CPP
  NIX_CFLAGS_COMPILE = [ "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H" ];

  postInstall =
    stdenv.lib.optionalString stdenv.isDarwin ''
    # Fixes "This application failed to start because it could not find or load the Qt
    # platform plugin "cocoa"."
    wrapQtApp $out/Mapper.app/Contents/MacOS/Mapper
    mkdir -p $out/bin
    ln -s $out/Mapper.app/Contents/MacOS/Mapper $out/bin/mapper
    '';

  meta = with stdenv.lib; {
    description = ''
      OpenOrienteering Mapper is an orienteering mapmaking program
      and provides a free alternative to the existing proprietary solution.
    '';
    homepage = https://www.openorienteering.org/apps/mapper/;
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [mpickering];
  };
}
