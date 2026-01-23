{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glfw,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableDebug ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mlx42";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "codam-coding-college";
    repo = "MLX42";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IMwDdWtbu882N43oTr/c6Fq34TduCuUt34Vh2Hx/TJY=";
  };

  postPatch = ''
    patchShebangs --build ./tools
  '';

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ glfw ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "DEBUG" enableDebug)
  ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./mlx42.pc} $out/lib/pkgconfig/mlx42.pc
  '';

  meta = {
    changelog = "https://github.com/codam-coding-college/MLX42/releases/tag/v${finalAttrs.version}";
    description = "Simple cross-platform graphics library that uses GLFW and OpenGL";
    homepage = "https://github.com/codam-coding-college/MLX42";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
})
