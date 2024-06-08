{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, perl
, wrapGAppsHook3
, wrapQtAppsHook
, qtbase
, qtcharts
, qtpositioning
, qtmultimedia
, qtserialport
, qtwayland
, qtwebengine
, calcmysky
, qxlsx
, indilib
, libnova
, qttools
, exiv2
, nlopt
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stellarium";
  version = "24.1";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${finalAttrs.version}";
    hash = "sha256-t3eFmiG9X2cmnjc/PQwZ2bw1SCHaNRA83wiT1cPbKJc=";
  };

  patches = [
    # Compatibility with INDI 2.0 series from https://github.com/Stellarium/stellarium/pull/3269
    (fetchpatch {
      url = "https://github.com/Stellarium/stellarium/commit/31fd7bebf33fa710ce53ac8375238a24758312bc.patch";
      hash = "sha256-eJEqqitZgtV6noeCi8pDBYMVTFIVWXZU1fiEvoilX8o=";
    })
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace 'SET(CMAKE_INSTALL_PREFIX "''${PROJECT_BINARY_DIR}/Stellarium.app/Contents")' \
                'SET(CMAKE_INSTALL_PREFIX "${placeholder "out"}/Applications/Stellarium.app/Contents")'
    substituteInPlace src/CMakeLists.txt \
      --replace "\''${_qt_bin_dir}/../" "${qtmultimedia}/lib/qt-6/"
  '';

  nativeBuildInputs = [
    cmake
    perl
    wrapGAppsHook3
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    qtbase
    qtcharts
    qtpositioning
    qtmultimedia
    qtserialport
    qtwebengine
    calcmysky
    qxlsx
    indilib
    libnova
    exiv2
    nlopt
  ] ++ lib.optionals stdenv.isLinux [
    qtwayland
  ];

  preConfigure = ''
    export SOURCE_DATE_EPOCH=$(date -d 20${lib.versions.major finalAttrs.version}0101 +%s)
  '' + lib.optionalString stdenv.isDarwin ''
    export LC_ALL=en_US.UTF-8
  '';

  # fatal error: 'QtSerialPort/QSerialPortInfo' file not found
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-F${qtserialport}/lib";

  dontWrapGApps = true;

  postInstall = lib.optionalString stdenv.isDarwin ''
    makeWrapper $out/Applications/Stellarium.app/Contents/MacOS/Stellarium $out/bin/stellarium
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta =  {
    description = "Free open-source planetarium";
    mainProgram = "stellarium";
    homepage = "https://stellarium.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kilianar ];
  };
})
