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

  GTest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v1.14.0";
    hash = "sha256-t0RchAHTJbuI5YW4uyBPykTvcjy90JW9AOPNjIhwh6U=";
  };

  # TODO use pkgs.minizip-ng (cmakeFlags = [ "-DMINIZIP_NG_LIBRARIES=${minizip-ng}/lib/libminizip-ng.so" ])
  # /build/source/src/gui/backup.cpp:28:10: fatal error: mz.h: No such file or directory
  minizip-ng = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "minizip-ng";
    rev = "4.0.5";
    hash = "sha256-f37IcSeMXS1Yp6Q6vxYCRjStdCSMVLJGR7ZPr4gm/VE=";
  };

  # TODO use pkgs.spdlog
  spdlog = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "v1.14.1";
    hash = "sha256-F7khXbMilbh5b+eKnzcB0fPPWQqUHqAYPWJb83OnUKQ=";
  };

  testing-plugins = fetchFromGitHub {
    owner = "Ortham";
    repo = "testing-plugins";
    rev = "1.4.1";
    hash = "sha256-R36jKArrslbGKOSnDyIeckSEgF1hIQmBloSH+Z8ZS9k=";
  };

  # ExternalProject tries to re-download tarballs if their hashes do not match.

  ValveFileVDF = fetchurl {
    url = "https://github.com/TinyTinni/ValveFileVDF/archive/c8adfc29e62cc980b595e965bedfb239087647ff.tar.gz";
    hash = "sha256-SKB4/x42DZwiF8m9LrdmkooCNLc7sr1FjQTGRkRmlVA=";
  };

in

stdenv.mkDerivation rec {
  pname = "loot";
  version = "0.22.4";

  src = fetchFromGitHub {
    owner = "loot";
    repo = pname;
    rev = version;
    hash = "sha256-qtbqYLxpjXYBs5xx0th5fUbrCixztO0ZhhP5u59GEkg=";
    # CMakeLists.txt gets the version string from HEAD
    leaveDotGit = true;
  };

  patches = [
    ./boost-shared.patch
    ./do-not-copy-test-resources.patch
  ];

  # prefetch remaining ExternalProjects
  postPatch = ''
    substituteInPlace src/gui/qt/helpers.cpp --replace-fail /usr/bin/xdg-open ${xdg-utils}/bin/xdg-open

    mkdir -p build/external/src
  '' + lib.concatMapStrings (tarball: ''
    ln -s ${tarball} build/external/src/${baseNameOf tarball.url}
  '') [
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
    "-DFETCHCONTENT_SOURCE_DIR_GTEST=${GTest}"
    "-DFETCHCONTENT_SOURCE_DIR_MINIZIP=${minizip-ng}"
    "-DFETCHCONTENT_SOURCE_DIR_SPDLOG=${spdlog}"
    # testing-plugins must be writable so we copy it and add it to cmakeFlags in preConfigure
  ];

  preConfigure = ''
    tmp=$(mktemp -d)
    cp -r ${testing-plugins} "$tmp/testing-plugins"
    chmod -R u+w "$tmp/testing-plugins"
    cmakeFlags="$cmakeFlags -DFETCHCONTENT_SOURCE_DIR_TESTING-PLUGINS=$tmp/testing-plugins"
  '';

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
