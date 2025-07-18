{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  gtest,
  glew,
  glfw,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,
  nix-update-script,
  withViewer ? false,
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
    # Vendor in nixpkgs libraries for `glew` and `glfw`, imgui is
    # unvendored due to a build failure
    ./cmake_find_package.patch
  ];

  nativeBuildInputs = [
    cmake
    eigen
  ];

  buildInputs =
    lib.optionals withViewer [
      glew
      glfw
    ]
    ++ lib.optionals (withViewer && stdenv.hostPlatform.isLinux) [
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
    (lib.cmakeBool "PMP_BUILD_VIS" withViewer)
    (lib.cmakeFeature "EIGEN3_INCLUDE_DIR" "${eigen}/include/eigen3")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  nativeCheckInputs = [ gtest ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ Library for processing and visualizing polygon surface meshes";
    longDescription = ''
      The Polygon Mesh Processing Library is a modern C++ open-source
      library for processing and visualizing polygon surface meshes.
      Its main features are:
      - An efficient and easy-to-use mesh data structure
      - Standard algorithms such as decimation, remeshing, subdivision,
        or smoothing
      - Ready-to-use visualization tools
      - Seamless cross-compilation to JavaScript
    '';
    homepage = "https://www.pmp-library.org";
    changelog = "https://github.com/pmp-library/pmp-library/blob/${finalAttrs.version}/CHANGELOG.md";
    # Upstream uses a MIT-style license with an explicit employer disclaimer
    # to clarify that the contributor’s employer bears no responsibility.
    # See: https://github.com/pmp-library/pmp-library/issues/237
    license = {
      shortName = "MIT License with employer disclaimer";
      fullName = "MIT License with employer disclaimer";
      free = true;
      redistributable = true;
      url = "https://github.com/pmp-library/pmp-library/blob/${finalAttrs.version}/LICENSE.txt";
    };
    maintainers = with lib.maintainers; [ yzx9 ];
    platforms = lib.platforms.all;
  };
})
