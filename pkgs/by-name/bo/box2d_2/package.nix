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
  libx11,
  libxcursor,
  libxi,
  libxinerama,
  libxrandr,
  libglut,
  xorgproto,

  nix-update-script,
}:

let
  inherit (lib) cmakeBool;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "box2d";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q+7YbDq+BUQklfduc7+Nfgy6XeAWouehfm8Ct7e++os=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glfw3
    libGLU
    libx11
    libxcursor
    libxi
    libxinerama
    libxrandr
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
