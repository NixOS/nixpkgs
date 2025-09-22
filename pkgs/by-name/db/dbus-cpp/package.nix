{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  boost186,
  cmake,
  dbus,
  doxygen,
  graphviz,
  gtest,
  libxml2,
  lomiri,
  pkg-config,
  process-cpp,
  properties-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbus-cpp";
  version = "5.0.5";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/dbus-cpp";
    tag = finalAttrs.version;
    hash = "sha256-+QqmZsBFmYRwaAFqRyMBxVFFrjZGBDdMaW4YD/7D2gU=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "examples"
  ];

  postPatch = ''
    substituteInPlace doc/CMakeLists.txt \
      --replace-fail 'DESTINATION share/''${CMAKE_PROJECT_NAME}/doc' 'DESTINATION ''${CMAKE_INSTALL_DOCDIR}'

    # Warning on aarch64-linux breaks build due to -Werror
    substituteInPlace CMakeLists.txt \
      --replace-fail '-Werror' ""

    # pkg-config output patching hook expects prefix variable here
    substituteInPlace data/dbus-cpp.pc.in \
      --replace-fail 'includedir=''${exec_prefix}' 'includedir=''${prefix}'
  ''
  + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(tests)' '# add_subdirectory(tests)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  buildInputs = [
    boost186 # uses boost/asio/io_service.hpp
    lomiri.cmake-extras
    dbus
    libxml2
    process-cpp
    properties-cpp
  ];

  nativeCheckInputs = [
    dbus
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "DBUS_CPP_ENABLE_DOC_GENERATION" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # DBus, parallelism messes with communication
  enableParallelChecking = false;

  preFixup = ''
    moveToOutput libexec/examples $examples
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      # Not bumped for 5.0.5: https://gitlab.com/ubports/development/core/lib-cpp/dbus-cpp/-/issues/9
      # Try again on next bump.
      versionCheck = finalAttrs.version != "5.0.5";
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Dbus-binding leveraging C++-11";
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/dbus-cpp";
    changelog = "https://gitlab.com/ubports/development/core/lib-cpp/dbus-cpp/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    mainProgram = "dbus-cppc";
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "dbus-cpp"
    ];
  };
})
