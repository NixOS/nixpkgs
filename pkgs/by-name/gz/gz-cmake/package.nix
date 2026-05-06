{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cppcheck,
  doxygen,
  graphviz,
  pkg-config,
  python3,
  nix-update-script,
}:
let
  version = "5.1.0";
  versionPrefix = "gz-cmake${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-cmake";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-cmake";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-o7JI3K1VuM1MKG0Wq0QUtyRI8cfBnHsW2mFuoapEQW8=";
  };

  postPatch = ''
    patchShebangs examples/test_c_child_requires_c_no_deps.bash
    substituteInPlace examples/CMakeLists.txt \
    --replace-fail "$""{CMAKE_INSTALL_LIBDIR}" "${
      if stdenv.hostPlatform.isDarwin then "lib" else "lib64"
    }"
  '';

  nativeBuildInputs = [
    cmake
    cppcheck
    doxygen
    graphviz
    pkg-config
    python3
  ];

  doBuildExamples = false;

  cmakeFlags = [
    (lib.cmakeBool "BUILDSYSTEM_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "BUILD_EXAMPLES" finalAttrs.doBuildExamples)
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=${versionPrefix}_([\\d\\.]+)" ];
  };

  meta = {
    description = "CMake modules to build Gazebo projects";
    homepage = "https://github.com/gazebosim/gz-cmake";
    changelog = "https://github.com/gazebosim/gz-cmake/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      guelakais
      taylorhoward92
    ];
  };
})
