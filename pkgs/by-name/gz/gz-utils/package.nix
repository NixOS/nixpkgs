{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  gz-cmake,
  doxygen,
  graphviz,

  # buildInputs
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
let
  version = "4.0.0";
  versionPrefix = "gz-utils${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-utils";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-utils";
    tag = "${versionPrefix}_${finalAttrs.version}";
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
    description = "General purpose utility classes and functions for the Gazebo libraries";
    homepage = "https://gazebosim.org/home";
    changelog = "https://github.com/gazebosim/gz-utils/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.windows;
    pkgConfigModules = [ "gz-utils" ];
    maintainers = with lib.maintainers; [
      guelakais
      taylorhoward92
    ];
  };
})
