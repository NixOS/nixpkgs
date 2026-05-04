{
  fetchFromGitHub,
  fetchzip,
  lib,
  runCommand,
  stdenv,

  backward-cpp,
  boost,
  bzip2,
  catch2,
  cmocka,
  exprtk,
  glibcLocales,
  libGL,
  libsForQt5,
  mimalloc,
  onetbb,
  pkg-config,
  python3,
  qt6,
  qt6Packages,
  ragel,
  simdutf,
  vectorscan,
  whereami,
  xxhash,
  xz,
  zlib,
  zstd,

  withQt6 ? true,
}:
let
  cpm_deps = {
    inherit
      backward-cpp
      cmocka
      exprtk
      mimalloc
      simdutf
      vectorscan
      whereami
      ;
    Catch2 = catch2;
    tbb = onetbb;
    xxHash = xxhash;

    CRoaring.src =
      let
        src = fetchFromGitHub {
          owner = "RoaringBitmap";
          repo = "CRoaring";
          rev = "v4.2.1";
          sha256 = "sha256-qOFkDu0JM+wBIlGGyewojicCp2pmtr643J3dW6el+O4=";
        };
      in
      runCommand "CRoaring-src" { } ''
        cp -r ${src}/ $out/
        substituteInPlace $out/CMakeLists.txt                                                   \
          --replace-fail 'configure_file ("''${CMAKE_CURRENT_SOURCE_DIR}/tests/config.h.in"' "" \
          --replace-fail '"''${CMAKE_CURRENT_SOURCE_DIR}/tests/config.h")' ""
      '';
    efsw.src = fetchFromGitHub {
      owner = "SpartanJ";
      repo = "efsw";
      rev = "1.4.1";
      sha256 = "sha256-c4+yNCCJnibiLGGsitbx+MkfzfsAXGtmfdJpBzphCIE=";
    };
    hyperscan.src = fetchFromGitHub {
      owner = "variar";
      repo = "hyperscan";
      rev = "0931a40e0cf1d7f92189bc546c3491ed5c113f8b";
      sha256 = "sha256-TfMyxyA37BtEszfdMPVyJg/cHqWb2v4SD2GRlNBHntk=";
    };
    KDSingleApplication.src = fetchFromGitHub {
      owner = "variar";
      repo = "KDSingleApplication";
      rev = "5b30db30266f92bc01f1439777803ce8dbf16c79";
      sha256 = "sha256-CNbJg+TEUt5lHiBEicVVIjEwRFGkdaPbsNmlK7XPenw=";
    };
    KDToolBox.src = fetchFromGitHub {
      owner = "KDAB";
      repo = "KDToolBox";
      rev = "6468867d1a46eabe1bcb2cd342f338fe66f06675";
      sha256 = "sha256-jR6rq8ha8o6rzucndkJu7a/YM5LSXEH6ZMVjpVgkxdI=";
    };
    KF5Archive.src =
      let
        klogg_karchive = fetchFromGitHub {
          owner = "variar";
          repo = "klogg_karchive";
          rev = "f546bf6ae66a8d34b43da5a41afcfbf4e1a47906";
          sha256 = "sha256-tI4vErSz8lSw5HRn8cP7xNdnilhvfCe9yIBHY1ucxw4=";
        };
      in
      runCommand "KF5Archive-src" { } ''
         cp -r ${klogg_karchive}/ $out/
        ${lib.optionalString withQt6 ''
          substituteInPlace $out/karchive/src/karchive.cpp \
            --replace-fail                                 \
              'arg(mode)'                                  \
              'arg(static_cast<int>(mode))'                \
            --replace-fail                                 \
              'arg(d->mode)'                               \
              'arg(static_cast<int>(d->mode))'

          substituteInPlace $out/karchive/src/kar.cpp      \
            --replace-fail                                 \
              'arg(mode)'                                  \
              'arg(static_cast<int>(mode))'

          substituteInPlace $out/karchive/src/krcc.cpp     \
            --replace-fail                                 \
              'arg(mode)'                                  \
              'arg(static_cast<int>(mode))'
        ''}
      '';
    macdeployqtfix.src = fetchFromGitHub {
      owner = "arl";
      repo = "macdeployqtfix";
      rev = "df888505849d3c06d20a4338af276dfa7d11826a";
      sha256 = "sha256-9dfIJmNxkHxrNGa6UOkLLXJwSEg9a8cLy3BkXUcFLCI=";
    };
    maddy.src = fetchFromGitHub {
      owner = "variar";
      repo = "maddy";
      rev = "602e26613e624535e2de883b3f2c98a16729d1d4";
      sha256 = "sha256-e1KECV651fCEWj9y/BwX3+K08mxTcKKlugGHpnGE2lY=";
    };
    robin_hood.src = fetchFromGitHub {
      owner = "martinus";
      repo = "robin-hood-hashing";
      rev = "3.11.5";
      sha256 = "sha256-J4u9Q6cXF0SLHbomP42AAn5LSKBYeVgTooOhqxOIpuM=";
    };
    streamvbyte.src = fetchFromGitHub {
      owner = "fast-pack";
      repo = "streamvbyte";
      rev = "1079110992a703a6fe5c351928815553d11d6ce9";
      sha256 = "sha256-Vz8RF0+vG3hrk/Q8U5ozLv9+hnKa5rLV6kOoG8hp7M8=";
    };
    type_safe.src = fetchFromGitHub {
      owner = "foonathan";
      repo = "type_safe";
      rev = "292e8c127037e33d92f8f52dab0f1184993942d0";
      sha256 = "sha256-DznGF5fbbIBZUk5ckHdKpFyog+eB7oPbO8io/AyOCIo=";
    };
    Uchardet.src = fetchzip {
      url = "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.8.tar.xz";
      sha256 = "sha256-5HSwFaclje5JkzOZKILgy2BGxLyFeDq/9p24KiTlTzE=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "klogg";
  version = "24.11.0";

  src = fetchFromGitHub {
    owner = "variar";
    repo = "klogg";
    rev = "25c7de6d8f6da2ce6a00882e5af70b4f331af4c5";
    sha256 = "sha256-DNLcvPKDQk5c9UfQY43zDB2Zq9ZbL0g1i2YF4uXcBp0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  env.LANG = "C.UTF-8";

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    (lib.cmakeBool "WARNINGS_AS_ERRORS" false)

    (lib.cmakeBool "KLOGG_USE_HYPERSCAN" false)
    (lib.cmakeBool "KLOGG_USE_VECTORSCAN" true)
    (lib.cmakeBool "KLOGG_USE_SENTRY" false)
    (lib.cmakeBool "KLOGG_BUILD_TESTS" false)

    (lib.cmakeBool "ENABLE_ROARING_TESTS" false)
    (lib.cmakeBool "ROARING_USE_CPM" false)

    (lib.cmakeBool "KDSingleApplication_QT6" withQt6)
    (lib.cmakeBool "KDSingleApplication_STATIC" true)
    (lib.cmakeBool "KDSingleApplication_EXAMPLES" false)
  ]
  ++ (lib.mapAttrsToList (n: x: "-DCPM_${n}_SOURCE=${x.src}") cpm_deps);

  preConfigure = lib.optionalString stdenv.isDarwin ''
    prependToVar cmakeFlags "-DCMAKE_CXX_COMPILER_AR=$(command -v $AR)"
    prependToVar cmakeFlags "-DCMAKE_CXX_COMPILER_RANLIB=$(command -v $RANLIB)"
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals withQt6 [ qt6.wrapQtAppsHook ]
  ++ lib.optionals (!withQt6) [ libsForQt5.wrapQtAppsHook ]
  ++ lib.flatten (lib.mapAttrsToList (_: x: x.nativeBuildInputs or [ ]) cpm_deps);

  buildInputs = [
    boost
    python3
    ragel

    bzip2
    libGL
    xz
    zlib
    zstd
  ]
  ++ lib.optionals withQt6 [
    qt6.wrapQtAppsHook
    qt6Packages.qtbase
    qt6Packages.qt5compat
    qt6Packages.qttools
    glibcLocales
  ]
  ++ lib.optionals (!withQt6) [
    libsForQt5.wrapQtAppsHook
    libsForQt5.qtbase
    libsForQt5.qttools
  ]
  ++ lib.flatten (lib.mapAttrsToList (_: x: x.buildInputs or [ ]) cpm_deps);

  qmakeFlags = [ "VERSION=${version}" ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir $out/bin $out/Applications
    cp $out/klogg.app/Contents/MacOS/klogg $out/bin/klogg
    mv $out/klogg.app/ $out/Applications/klogg.app/
  '';

  meta = with lib; {
    description = "Really fast log explorer based on glogg project";
    mainProgram = "klogg";
    longDescription = ''
      klogg is an open source multi-platform GUI application to search through all kinds of text log files using regular expressions. It has started as fork of glogg project created by Nicolas Bonnefon, and has evolved into a separate project with a lot of new features and improvements.
    '';
    homepage = "https://klogg.filimonov.dev/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
