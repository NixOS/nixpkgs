{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  gtest,
  nix-update-script,

  viewerSupport ? false,
  glew,
  glfw,
  imgui,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pmp-library";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "pmp-library";
    repo = "pmp-library";
    tag = finalAttrs.version;
    hash = "sha256-h9uYGEg+0Pzj5eQl5Suuj0ePsCzPHOI0kLJEsa32nVQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./cmake_find_package.patch
  ];

  nativeBuildInputs = [
    cmake
    eigen
  ];

  buildInputs =
    lib.optionals viewerSupport [
      glew
      glfw
      imgui
    ]
    ++ lib.optionals (viewerSupport && stdenv.hostPlatform.isLinux) [
      libGL
      libX11
      libXcursor
      libXi
      libXinerama
      libXrandr
    ];

  cmakeFlags = [
    (lib.cmakeBool "PMP_BUILD_DOCS" false)
    (lib.cmakeBool "PMP_BUILD_EXAMPLES" false)
    (lib.cmakeBool "PMP_BUILD_VIS" viewerSupport)
    "-DEIGEN3_INCLUDE_DIR=${eigen}/include/eigen3"
  ];

  doCheck = true;
  nativeCheckInputs = [
    gtest
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.pmp-library.org";
    description = "Polygon Mesh Processing Library";
    changelog = "https://github.com/pmp-library/pmp-library/blob/${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
})
