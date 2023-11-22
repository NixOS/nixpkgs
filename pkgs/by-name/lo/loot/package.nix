{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, boost
, cmake
, git
, libloot
, ogdf
, pkg-config
, qt6Packages
, tbb_2021_11
, tomlplusplus
, xdg-utils
, zlib
}:

let

  GTest = fetchurl {
    url = "https://github.com/google/googletest/archive/v1.14.0.tar.gz";
    hash = "sha256-itWYxzrXluDYKAsILOvYKmMNc+c808cAV5OKZQG7pdc=";
  };

  # TODO use pkgs.minizip-ng (cmakeFlags = [ "-DMINIZIP_NG_LIBRARIES=${minizip-ng}/lib/libminizip-ng.so" ])
  # /build/source/src/gui/backup.cpp:28:10: fatal error: mz.h: No such file or directory
  minizip-ng = fetchurl {
    url = "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.1.tar.gz";
    hash = "sha256-Y+R6K026wNpQH0P02nTxGN+z7w3uD/u+iUKCcQAiYPg=";
  };

  testing-plugins = fetchurl {
    url = "https://github.com/Ortham/testing-plugins/archive/1.4.1.tar.gz";
    hash = "sha256-V/gklac3ATwbgo1D++h+3LV3aPhcZBbo0X8nPWkmkc8=";
  };

  # TODO use pkgs.spdlog
  spdlog = fetchurl {
    url = "https://github.com/gabime/spdlog/archive/v1.12.0.tar.gz";
    hash = "sha256-Tczy0Q9BDB4v6v+Jlmv8SaGrsp728IJGM1sRDgAeCak=";
  };

  ValveFileVDF = fetchurl {
    url = "https://github.com/TinyTinni/ValveFileVDF/archive/3ed733cac6d0306e39d228d4a00311adfcc682f6.tar.gz";
    hash = "sha256-P5OvndpqXuvVM5jlcrd+ucpIjn1CJUPdVxvuCOMdtIE=";
  };

in

stdenv.mkDerivation rec {
  pname = "loot";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "loot";
    repo = pname;
    rev = version;
    hash = "sha256-82KgpLN7KOgxR2qpU4U1z+xg/Ww2nvio63eB3X7evU4=";
    # CMakeLists.txt gets the version string from HEAD
    leaveDotGit = true;
  };

  patches = [
    ./boost-shared.patch
    ./remove-external-projects.patch
    ./do-not-copy-test-resources.patch
  ];

  # prefetch remaining ExternalProjects
  postPatch = ''
    substituteInPlace src/gui/qt/helpers.cpp --replace-fail /usr/bin/xdg-open ${xdg-utils}/bin/xdg-open

    mkdir -p build/external/src
  '' + lib.concatMapStrings (tarball: ''
    ln -s ${tarball} build/external/src/${baseNameOf tarball.url}
  '') [
    GTest
    minizip-ng
    testing-plugins
    spdlog
    ValveFileVDF
  ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    qt6Packages.wrapQtAppsHook
    tomlplusplus
  ];

  buildInputs = [
    boost
    libloot
    ogdf
    qt6Packages.qtbase
    tbb_2021_11
    xdg-utils
  ];

  cmakeFlags = [
    "-Dtomlplusplus_SOURCE_DIR=${tomlplusplus}"
    "-DLIBLOOT_SHARED_LIBRARY=${libloot}/lib/libloot.so"
    "-DZLIB_ROOT=${zlib}"
    "-DZLIB_LIBRARY=${zlib}/lib/libz.so"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    # GetPreferredUILanguages.shouldReturnAtLeastOneLanguage needs a locale
    ./loot_gui_tests --gtest_filter='-GetPreferredUILanguages.shouldReturnAtLeastOneLanguage'
    LANG=en_US.UTF-8 ./loot_gui_tests --gtest_filter='GetPreferredUILanguages.shouldReturnAtLeastOneLanguage'

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 LOOT "$out/bin/LOOT"

    runHook postInstall
  '';

  # run after qt6Packages.wrapQtAppsHook, so only one wrapper is created
  postFixup = ''
    ln -s LOOT "$out/bin/loot"
  '';

  meta = with lib; {
    homepage = "https://github.com/loot/loot";
    description = "A modding utility for Starfield and some Elder Scrolls and Fallout games";
    license = licenses.gpl3Plus;
    mainProgram = "LOOT";
    maintainers = with maintainers; [ schnusch ];
  };
}
