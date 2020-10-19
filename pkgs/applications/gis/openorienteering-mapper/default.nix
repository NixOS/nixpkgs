{ stdenv
, mkDerivation
, fetchFromGitHub
, substituteAll
, gdal
, cmake
, ninja
, proj
, clipper
, zlib
, qttools
, qtlocation
, qtsensors
, qttranslations
, doxygen
, cups
, qtimageformats
}:

mkDerivation rec {
  pname = "OpenOrienteering-Mapper";
  version = "0.9.4";

  buildInputs = [
    gdal
    qtlocation
    qtimageformats
    qtsensors
    clipper
    zlib
    proj
    cups
  ];

  nativeBuildInputs = [ cmake doxygen ninja qttools ];

  src = fetchFromGitHub {
    owner = "OpenOrienteering";
    repo = "mapper";
    rev = "v${version}";
    sha256 = "13k9dirqm74lknhr8w121zr1hjd9gm1y73cj4rrj98rx44dzmk7b";
  };

  patches = (substituteAll {
    # See https://github.com/NixOS/nixpkgs/issues/86054
    src = ./fix-qttranslations-path.diff;
    inherit qttranslations;
  });

  cmakeFlags = [
    # Building the manual and bundling licenses fails
    # See https://github.com/NixOS/nixpkgs/issues/85306
    "-DLICENSING_PROVIDER:BOOL=OFF"
    "-DMapper_MANUAL_QTHELP:BOOL=OFF"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
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
  ];

  postInstall = with stdenv; lib.optionalString isDarwin ''
    mkdir -p $out/Applications
    mv $out/Mapper.app $out/Applications
    # Fixes "This application failed to start because it could not find or load the Qt
    # platform plugin "cocoa"."
    wrapQtApp $out/Applications/Mapper.app/Contents/MacOS/Mapper
    mkdir -p $out/bin
    ln -s $out/Applications/Mapper.app/Contents/MacOS/Mapper $out/bin/mapper
  '';

  meta = with stdenv.lib; {
    description = ''
      OpenOrienteering Mapper is an orienteering mapmaking program
      and provides a free alternative to the existing proprietary solution.
    '';
    homepage = "https://www.openorienteering.org/apps/mapper/";
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ mpickering sikmir ];
  };
}
