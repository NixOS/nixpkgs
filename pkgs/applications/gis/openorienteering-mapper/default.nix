{ lib, stdenv
, mkDerivation
, fetchFromGitHub
, fetchpatch
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
  version = "0.9.5";

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
    sha256 = "1w8ikqpgi0ksrzjal5ihfaik4grc5v3gdnnv79j20xkr2p4yn1h5";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/86054
    (substituteAll {
      src = ./fix-qttranslations-path.diff;
      inherit qttranslations;
    })
    # https://github.com/OpenOrienteering/mapper/pull/1907
    (fetchpatch {
      url = "https://github.com/OpenOrienteering/mapper/commit/bc52aa567e90a58d6963b44d5ae1909f3f841508.patch";
      sha256 = "1bkckapzccn6k0ri6bgrr0nhis9498fnwj7b32s2ysym8zcg0355";
    })
  ];

  cmakeFlags = [
    # Building the manual and bundling licenses fails
    # See https://github.com/NixOS/nixpkgs/issues/85306
    "-DLICENSING_PROVIDER:BOOL=OFF"
    "-DMapper_MANUAL_QTHELP:BOOL=OFF"
  ] ++ lib.optionals stdenv.isDarwin [
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
    mkdir -p $out/bin
    ln -s $out/Applications/Mapper.app/Contents/MacOS/Mapper $out/bin/mapper
  '';

  meta = with lib; {
    description = ''
      OpenOrienteering Mapper is an orienteering mapmaking program
      and provides a free alternative to the existing proprietary solution.
    '';
    homepage = "https://www.openorienteering.org/apps/mapper/";
    changelog = "https://github.com/OpenOrienteering/mapper/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ mpickering sikmir ];
  };
}
