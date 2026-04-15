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
}:
let
  version = "10.0.0";
  versionPrefix = "gz-gui${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-gui";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-gui";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-s34FtTFWV6+qakYz6atZfl20y7u8KQAU58a63FghhKc=";
  };

  patches = [
    # Fix test race: TopicEcho_TEST and Publisher_TEST both used the /echo topic;
    # use a unique topic name in TopicEcho_TEST to avoid cross-contamination
    # under parallel ctest execution.
    # https://github.com/gazebosim/gz-gui/pull/762
    ./patches/pr-762.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    protobuf
  ];

  # Nix sets CMAKE_INSTALL_LIBDIR to an absolute store path, which produces
  # broken doubled paths in getPluginInstallDir().  Force it to be relative.
  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  buildInputs = [
    gz-cmake
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

    # Some test cases use $HOME
    export HOME=$(mktemp -d)

    # Test binaries are not wrapped, so QML modules must be found explicitly
    export QML_IMPORT_PATH="${qt6.qtdeclarative}/lib/qt-6/qml:${qt6.qt5compat}/lib/qt-6/qml:${qt6.qtquick3d}/lib/qt-6/qml''${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Test binaries lack RPATH for transitive dependencies
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ libsodium ]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

    # Plugins are not installed yet during check; point tests at the build tree
    export GZ_GUI_PLUGIN_PATH="$PWD/lib''${GZ_GUI_PLUGIN_PATH:+:$GZ_GUI_PLUGIN_PATH}"
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
})
