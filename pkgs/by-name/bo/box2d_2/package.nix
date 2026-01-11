{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # buildInputs
  glfw3,
  libGLU,
  libX11,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,
  libglut,
  xorgproto,

  nix-update-script,
}:

let
  inherit (lib) cmakeBool;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "box2d";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yvhpgiZpjTPeSY7Ma1bh4LwIokUUKB10v2WHlamL9D8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glfw3
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
    changelog = "https://github.com/erincatto/box2d/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.zlib;
  };
})
