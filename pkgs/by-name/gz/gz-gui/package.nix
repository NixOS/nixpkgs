{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gz-cmake,
  gz-common,
  gz-msgs,
  gz-plugin,
  gz-rendering,
  gz-transport,
  protobuf,
  tinyxml-2,
  qt6,
  libsodium,
  ctestCheckHook,
  python3,
  gtest,
  testers,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    versionPrefix = "gz-gui${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "gz-gui";
    version = "10.1.0";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "gz-gui";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-UGvahx9+AJQ15ZlKymTc/S4bZkfK+KjIn17Ld1TSX9s=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
      qt6.wrapQtAppsHook
      protobuf
    ];

    # Nix sets CMAKE_INSTALL_LIBDIR to an absolute store path, which produces
    # broken doubled paths in getPluginInstallDir().  Force it to be relative.
    cmakeFlags = [ (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib") ];

    buildInputs = [
      gz-cmake
      # zeromq's CMake target links libsodium by absolute path, so it becomes a
      # direct DT_NEEDED of anything linking gz-transport.
      libsodium
    ];

    propagatedBuildInputs = [
      gz-common
      gz-msgs
      gz-plugin
      gz-rendering
      gz-transport
      protobuf
      tinyxml-2
      qt6.qt5compat
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtquick3d
    ];

    nativeCheckInputs = [
      ctestCheckHook
      python3
      writableTmpDirAsHomeHook
    ];

    checkInputs = [ gtest ];

    disabledTests = [
      # Tries to build examples against the installed package, which is not
      # available during the check phase.
      "INTEGRATION_ExamplesBuild_TEST"

      # Requires GPU/display server (SEGFAULTs without rendering context) which
      # is not available in the Nix sandbox.
      "INTEGRATION_camera_tracking"
      "INTEGRATION_marker_manager"
      "INTEGRATION_minimal_scene"
      "INTEGRATION_transport_scene_manager"
    ];

    preCheck = ''
      # Headless Qt workaround for sandboxed builds.
      export QT_QPA_PLATFORM=offscreen

      # Test binaries are not wrapped, so QML modules must be found explicitly
      export QML_IMPORT_PATH="${qt6.qtdeclarative}/lib/qt-6/qml:${qt6.qt5compat}/lib/qt-6/qml:${qt6.qtquick3d}/lib/qt-6/qml''${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # Plugins are not installed yet during check; point tests at the build tree
      export GZ_GUI_PLUGIN_PATH="$PWD/lib''${GZ_GUI_PLUGIN_PATH:+:$GZ_GUI_PLUGIN_PATH}"
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) ''
      # Transport waits for its own subscriber, then reads fields that the
      # plotting interface's separate subscription may still be updating.
      export GTEST_FILTER=-PlottingInterfaceTest.Transport
    '';

    doCheck = true;

    passthru = {
      tests.pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
      updateScript = nix-update-script {
        extraArgs = [ "--version-regex=${versionPrefix}_([\\d\\.]+)" ];
      };
    };

    meta = {
      description = "QML-based application framework for Gazebo robot simulation tools";
      homepage = "https://github.com/gazebosim/gz-gui";
      changelog = "https://github.com/gazebosim/gz-gui/blob/${finalAttrs.src.tag}/Changelog.md";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      pkgConfigModules = [ "gz-gui" ];
      maintainers = with lib.maintainers; [ taylorhoward92 ];
    };
  }
)
