{
  lib,
  stdenv,
  fetchFromGitHub,

  substituteAll,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # buildInputs
  glfw3,
  imgui,
  libGL,
  libGLU,
  libX11,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,
  libglut,
  xorgproto,
}:

let
  inherit (lib) cmakeBool;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "box2d";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZS6v+Oq7wWjUY3ZEp6h7W7fQ5nUienz9N+ntXodgAVQ=";
  };

  patches = [
    # prevent CMake from trying to download some libraries from the internet
    (substituteAll {
      src = ./cmake_dont_fetch_enkits.patch;
      enkits_src = fetchFromGitHub {
        owner = "dougbinks";
        repo = "enkiTS";
        rev = "686d0ec31829e0d9e5edf9ceb68c40f9b9b20ea9";
        hash = "sha256-CerLj/WY+J3mrMvv7dGmZltjAM9v5C/IY4X+Ph78HVs=";
      };
    })
    ./cmake_use_system_glfw_and_imgui.patch
  ];

  # Taken from https://github.com/erincatto/box2d/pull/784
  postPatch = ''
    substituteInPlace samples/settings.cpp \
      --replace-fail "fread( data, size, 1, file );" "size_t count = fread( data, size, 1, file );"
    substituteInPlace samples/shader.cpp \
      --replace-fail "fread( source, size, 1, file );" "size_t count = fread( source, size, 1, file );"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glfw3
    imgui
    libGL
    libGLU
    libX11
    libXcursor
    libXi
    libXinerama
    libXrandr
    libglut
    xorgproto
  ];

  cmakeFlags = [
    (cmakeBool "BOX2D_BUILD_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  meta = {
    description = "2D physics engine";
    homepage = "https://box2d.org/";
    changelog = "https://github.com/erincatto/box2d/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.zlib;
  };
})
