{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  doxygen,
  graphviz,

  # propagatedNativeBuildInputs
  gz-cmake, # downstream consumers need gz-cmake's CMake modules

  # propagatedBuildInputs
  cli11,
  spdlog,

  # nativeCheckInputs
  ctestCheckHook,
  python3,

  # checkInputs
  gtest,

  nix-update-script,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-utils";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-utils";
    tag = "gz-utils${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-fZonC/o5CNHdK/R3IgEoo1llehy36MwvXPQCgFnP8Ls=";
  };

  outputs = [
    "doc"
    "out"
  ];

  # Remove vendored gtest, use nixpkgs' version instead.
  postPatch = ''
    rm -r test/gtest_vendor

    substituteInPlace test/CMakeLists.txt --replace-fail \
      "add_subdirectory(gtest_vendor)" "# add_subdirectory(gtest_vendor)"
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  propagatedNativeBuildInputs = [
    gz-cmake
  ];

  propagatedBuildInputs = [
    cli11
    spdlog
  ];

  # Indicate to CMake that we are not using the vendored CLI11 library.
  # The integration tests make (unintentional?) unconditional usage of the vendored
  # CLI11 library, so we can't remove that.
  cmakeFlags = [
    (lib.cmakeBool "GZ_UTILS_VENDOR_CLI11" false)
  ];

  postBuild = ''
    make doc
    cp -r doxygen/html $doc
  '';

  nativeCheckInputs = [
    ctestCheckHook
    python3
  ];

  checkInputs = [ gtest ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    # Spawning a non-existent executable surfaces the child's 127 exit status
    # rather than -1, and the handle still reports the process as alive, so the
    # exec-failure assertions in Subprocess.CreateInvalid{,Spaces} fail.
    "INTEGRATION_subprocess_TEST"
  ];

  doCheck = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=gz-utils${lib.versions.major finalAttrs.version}_([\\d\\.]+)"
      ];
    };
  };

  meta = {
    description = "General purpose utility classes and functions for the Gazebo libraries";
    homepage = "https://gazebosim.org/home";
    changelog = "https://github.com/gazebosim/gz-utils/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [ "gz-utils" ];
    maintainers = with lib.maintainers; [
      guelakais
      taylorhoward92
    ];
  };
})
