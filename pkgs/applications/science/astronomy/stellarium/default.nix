{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, perl
, wrapGAppsHook
, wrapQtAppsHook
, qtbase
, qtcharts
, qtpositioning
, qtmultimedia
, qtserialport
, qttranslations
, qtwayland
, qtwebengine
, calcmysky
, qxlsx
, indilib
, libnova
}:

stdenv.mkDerivation rec {
  pname = "stellarium";
  version = "23.2";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${version}";
    hash = "sha256-8Iheb/9wjf0u10ZQRkLMLNN2s7P++Fqcr26iatiKcTo=";
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
    wrapGAppsHook
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtcharts
    qtpositioning
    qtmultimedia
    qtserialport
    qttranslations
    qtwebengine
    calcmysky
    qxlsx
    indilib
    libnova
  ] ++ lib.optionals stdenv.isLinux [
    qtwayland
  ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
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

  meta = with lib; {
    description = "Free open-source planetarium";
    homepage = "https://stellarium.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
