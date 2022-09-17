{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, fetchpatch
, clipper
, cmake
, cups
, doxygen
, gdal
, ninja
, proj
, qtimageformats
, qtlocation
, qtsensors
, qttools
, qttranslations
, substituteAll
, zlib
}:

mkDerivation rec {
  pname = "OpenOrienteering-Mapper";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "OpenOrienteering";
    repo = "mapper";
    rev = "v${version}";
    hash = "sha256-BQbryRV5diBkOtva9sYuLD8yo3IwFqrkz3qC+C6eEfE=";
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

  nativeBuildInputs = [
    cmake
    doxygen
    ninja
    qttools
  ];

  buildInputs = [
    clipper
    cups
    gdal
    proj
    qtimageformats
    qtlocation
    qtsensors
    zlib
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
    homepage = "https://www.openorienteering.org/apps/mapper/";
    description = "An orienteering mapmaking program";
    changelog = "https://github.com/OpenOrienteering/mapper/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mpickering sikmir ];
    platforms = with platforms; unix;
    broken = stdenv.isDarwin;
  };
}
