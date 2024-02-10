{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, boost
, cmake
, dbus
, doxygen
, graphviz
, gtest
, libxml2
, lomiri
, pkg-config
, process-cpp
, properties-cpp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbus-cpp";
  version = "5.0.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/dbus-cpp";
    rev = finalAttrs.version;
    hash = "sha256-t8SzPRUuKeEchT8vAsITf8MwbgHA+mR5C9CnkdVyX7s=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "examples"
  ];

  patches = [
    # Handle already-stolen dbus call better
    # Remove when version > 5.0.3
    (fetchpatch {
      name = "0001-dbus-cpp-src-Dont-steal-a-pending-dbus-call-more-then-once.patch";
      url = "https://gitlab.com/ubports/development/core/lib-cpp/dbus-cpp/-/commit/9f3d1ff2b1c6c732285949c3dbb35e40cf55ea92.patch";
      hash = "sha256-xzOCIJVsK2J+X9RsV930R9uw6h4UxqwSaNOgv8v4qQU=";
    })

    # Fix GCC13 compilation
    # Remove when version > 5.0.3
    (fetchpatch {
      name = "0002-dbus-cpp-Add-missing-headers-for-GCC13.patch";
      url = "https://gitlab.com/ubports/development/core/lib-cpp/dbus-cpp/-/commit/c761b1eec084962dbe64d35d7f7b86dcbe57a3f7.patch";
      hash = "sha256-/tKe3iHWxP9jWtpdgwwRynj8565u9LxCt4WXJDXzgX4=";
    })
  ];

  postPatch = ''
    substituteInPlace doc/CMakeLists.txt \
      --replace 'DESTINATION share/''${CMAKE_PROJECT_NAME}/doc' 'DESTINATION ''${CMAKE_INSTALL_DOCDIR}'

    # Warning on aarch64-linux breaks build due to -Werror
    substituteInPlace CMakeLists.txt \
      --replace '-Werror' ""

    # pkg-config output patching hook expects prefix variable here
    substituteInPlace data/dbus-cpp.pc.in \
      --replace 'includedir=''${exec_prefix}' 'includedir=''${prefix}'
  '' + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    sed -i -e '/add_subdirectory(tests)/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  buildInputs = [
    boost
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
    "-DDBUS_CPP_ENABLE_DOC_GENERATION=ON"
  ];

  # Too flaky on ARM CI & for some amd64 users
  doCheck = false;

  # DBus, parallelism messes with communication
  enableParallelChecking = false;

  preFixup = ''
    moveToOutput libexec/examples $examples
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "A dbus-binding leveraging C++-11";
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/dbus-cpp";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    mainProgram = "dbus-cppc";
    platforms = platforms.linux;
    pkgConfigModules = [
      "dbus-cpp"
    ];
  };
})
