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
  version = "5.0.0";
  versionPrefix = "gz-cmake${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-cmake";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-cmake";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-XF7oglj9Xr6F8a+6uowrY5a040yl4FZlFfW/Y0BJwOs=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CMake modules to build Gazebo projects";
    homepage = "https://github.com/gazebosim/gz-cmake";
    changelog = "https://github.com/gazebosim/gz-cmake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ guelakais ];
    badPlatforms = lib.platforms.darwin; # hard replicable building error
  };
})
