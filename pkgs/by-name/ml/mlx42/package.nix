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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "codam-coding-college";
    repo = "MLX42";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-/HCP6F7N+J97n4orlLxg/4agEoq4+rJdpeW/3q+DI1I=";
  };

  postPatch =
    ''
      patchShebangs --build ./tools
    ''
    + lib.optionalString enableShared ''
      substituteInPlace CMakeLists.txt \
          --replace-fail "mlx42 STATIC" "mlx42 SHARED"
    '';

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ glfw ];

  cmakeFlags = [ (lib.cmakeBool "DEBUG" enableDebug) ];

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
