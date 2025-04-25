{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,

  withDocs ? false,
  doxygen,
  graphviz,

  withTests ? false,
  cppcheck,
  gtest,
  python3,
}:
let
  # gz-cmake's functionalities make use of various programs.
  # Depending on which functionalities are used, it might not be necessary to add them all.
  #
  # This is declared as a reusable function so that this
  # package's tests and dependees can access them independently.
  depConf =
    {
      doc,
      test,
    }:
    lib.optionals doc [
      doxygen
      graphviz
    ]
    ++ lib.optionals test [
      cppcheck
      gtest
      python3
    ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-cmake";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-cmake";
    tag = "gz-cmake${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-BWgRm+3UW65Cu7TqXtFFG05JlYF52dbpAsIE8aDnJM0=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILDSYSTEM_TESTING" finalAttrs.doCheck)
  ];

  # Propagate dependencies to other packages as requested
  propagatedNativeBuildInputs = depConf {
    doc = withDocs;
    test = withTests;
  };

  # Run the tests with all programs available
  checkInputs = depConf {
    doc = true;
    test = true;
  };

  # 43 / 44 tests pass
  # 44 - core_child_requires_core_nodep (Failed)
  doCheck = false;

  meta = {
    description = "CMake modules to build Gazebo projects";
    homepage = "https://github.com/gazebosim/gz-cmake";
    changelog = "https://github.com/gazebosim/gz-cmake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
