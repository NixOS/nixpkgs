{
  stdenv,
  lib,
  fetchFromGitLab,
  runCommand,
  cmake,
  leveldb,
  lomiri,
  pkg-config,
  pyotherside,
  python3,
  libsForQt5,
  fetchpatch,
}:

let
  pylibs = python3.withPackages (ps: with ps; [
    markdown
    markupsafe
    cssutils
    jinja2
    pygments
    html2text
    importlib-metadata
    zipp
    soupsieve
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dekko";
  version = "0.4.1";

  src = fetchFromGitLab {
    #owner = "dekkan";
    #repo = "dekko";
    #rev = "${finalAttrs.version}";
    #hash = "sha256-RTdDTVexe3neuqm6oU2jzURug9mfKQMTSL3jRu4spkc=";
    owner = "gberh";
    repo = "dekko";
    rev = "7c71d998df7e6415e3564de4c082682c34f60cc3";
    hash = "sha256-hfZJxVx7vwGXvqdUSkJ1g525h+b+Atye/Qw3pW320AI=";
    fetchSubmodules = true;
  };

  patches = [
/*
    (runCommand "qmf-using-qt5_use_modules" {} ''
      cp ${../qmf/0001-Stop-using-qt5_use_modules.patch} $out
      substituteInPlace $out \
        --replace-fail ' a/' ' a/upstream/qmf/' \
        --replace-fail ' b/' ' b/upstream/qmf/'
    '')
*/
    (fetchpatch {
      url = "https://salsa.debian.org/gber/dekko/-/raw/0881b7b96edb5c814fdd6c95b97aacefa046a42c/debian/patches/2002-Build-against-Debian-qmf.patch";
      hash = "sha256-2RpNcxCwo9dx40eHqcZHLhk/2A+P6N87N3JYWcde3Sg=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'COMMAND ''${QMAKE_EXECUTABLE} -query QT_INSTALL_QML' 'COMMAND echo "''${CMAKE_INSTALL_PREFIX}/${libsForQt5.qtbase.qtQmlPrefix}"'
    cp ${./CMakeLists.txt} upstream/quick-flux/CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = with libsForQt5; [
    cmake
    pkg-config
    (python3.withPackages (ps: with ps; [
      setuptools
    ]))
    qttools # lrelease
    wrapQtAppsHook
  ];

  buildInputs = with libsForQt5; [
    accounts-qt
    leveldb
    lomiri.lomiri-api
    lomiri.lomiri-content-hub
    lomiri.lomiri-indicator-network
    lomiri.qqc2-suru-style
    pyotherside
    qtbase
    qtdeclarative
    #qtmessagingframework
    qtquickcontrols2
    qtwebengine
    /* (quickflux.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [
        # Allow building as a real QML module
        # https://github.com/benlau/quickflux/pull/35
        (fetchpatch {
          name = "0001-quickflux-Support-building-shared-and-QML-module.patch";
          url = "https://github.com/benlau/quickflux/commit/77a92e6928b92b708d8c8634a34bca90a0d3d2de.patch";
          hash = "sha256-bRA87kwS7ItdLgDEtWIZkW2cHrUXumHvgzPtoNPCSX0=";
        })
        (fetchpatch {
          name = "0002-quickflux-Use-BUILD_SHARED_LIBS.patch";
          url = "https://github.com/benlau/quickflux/commit/c044027ca39bd48d60eb66ea4ec41ba56e5daacb.patch";
          hash = "sha256-KdwMTfpW3AM0uEdq0I/A4Pqy2JzIm8c9pn2L2weMKeA=";
        })
        (fetchpatch {
          name = "0003-quickflux-Configure-qmldir-with-@ONLY.patch";
          url = "https://github.com/benlau/quickflux/commit/68f1ec392a673d2d4d30238a047f0e5f1d7c732b.patch";
          hash = "sha256-uoqfaBjOnZEdcX15nfDvXSJ6FtcQnF1apJjAR6DL2uw=";
        })
        (fetchpatch {
          name = "0004-quickflux-Adjust-QT_IMPORTS_DIR-detection.patch";
          url = "https://github.com/benlau/quickflux/commit/96afd7aebb412ca484dff020e969fb92e26dfc5f.patch";
          hash = "sha256-LOiDi6mlptDjt+TgwvvYW/YVCyz1VllXWOqj1fxcqXs=";
        })
        (fetchpatch {
          name = "0005-quickflux-Fix-SOVERSION_MINOR-typo.patch";
          url = "https://github.com/benlau/quickflux/commit/a29c4d0769eb5a54d01dec8b064bc5167f947bd4.patch";
          hash = "sha256-z6NOeYm20cS2KqMruN0fpWvbdL780eEPw3iyA7DuO9c=";
        })
      ];

      # Overriding this to remove only a single --replace line, and add another one
      postPatch = ''
        # Don't hardcode static linking, let stdenv decide
        # Use GNUInstallDirs
        substituteInPlace CMakeLists.txt \
          --replace-fail 'DESTINATION include' 'DESTINATION ''${CMAKE_INSTALL_INCLUDEDIR}' \
          --replace-fail 'exec_program(''${QMAKE_EXECUTABLE} ARGS "-query ''${VAR}"' 'exec_program(echo ARGS "-n ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"'
      '';
    })) */
    signond
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeFeature "DEKKO_PYTHON_DIR" "${pylibs}/${python3.sitePackages}")
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Debug")
    (lib.cmakeBool "DEKKO_SYSTEM_QMF" false)
    (lib.cmakeBool "DEKKO_SYSTEM_QUICKFLUX" false)
  ];

  dontStrip = true;

  # No top-level tests
  doCheck = false;

  /*
  preFixup = ''
    qtWrapperArgs+=(
      --set DEKKO_PLUGINS $out/lib/dekko/plugins
    )
  '';
  */

  meta = {
    description = "Convergent E-Mail client for Ubuntu Touch devices";
    homepage = "https://gitlab.com/dekkan/dekko";
    changelog = "https://gitlab.com/dekkan/dekko/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "dekko";
  };
})
