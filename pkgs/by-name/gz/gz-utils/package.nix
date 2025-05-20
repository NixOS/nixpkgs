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
  python3,

  # checkInputs
  gtest,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-utils";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-utils";
    tag = "gz-utils${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-fYzysdB608jfMb/EbqiGD4hXmPxcaVTUrt9Wx0dBlto=";
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
    gz-cmake
    doxygen
    graphviz
  ];

  buildInputs = [
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

  nativeCheckInputs = [ python3 ];

  checkInputs = [ gtest ];

  doCheck = true;

  meta = {
    description = "General purpose utility classes and functions for the Gazebo libraries";
    homepage = "https://gazebosim.org/home";
    changelog = "https://github.com/gazebosim/gz-utils/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
