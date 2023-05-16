{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cmake
, perl
, wrapGAppsHook
, wrapQtAppsHook
, qtbase
, qtcharts
, qtpositioning
, qtmultimedia
, qtserialport
<<<<<<< HEAD
=======
, qttranslations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qtwayland
, qtwebengine
, calcmysky
, qxlsx
, indilib
, libnova
<<<<<<< HEAD
, qttools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "stellarium";
<<<<<<< HEAD
  version = "23.2";
=======
  version = "23.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8Iheb/9wjf0u10ZQRkLMLNN2s7P++Fqcr26iatiKcTo=";
  };

  patches = [
    # Compatibility with INDI 2.0 series from https://github.com/Stellarium/stellarium/pull/3269
    (fetchpatch {
      url = "https://github.com/Stellarium/stellarium/commit/31fd7bebf33fa710ce53ac8375238a24758312bc.patch";
      hash = "sha256-eJEqqitZgtV6noeCi8pDBYMVTFIVWXZU1fiEvoilX8o=";
    })
  ];

=======
    hash = "sha256-7jzS3pRklPsCTgCr3nrywfHCNlBDHuyuGGvrVoI9+A0=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    qttools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    qtbase
    qtcharts
    qtpositioning
    qtmultimedia
    qtserialport
<<<<<<< HEAD
=======
    qttranslations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
