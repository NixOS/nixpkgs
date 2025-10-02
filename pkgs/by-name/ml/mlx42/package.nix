{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
    tag = "v${finalAttrs.version}";
    hash = "sha256-/HCP6F7N+J97n4orlLxg/4agEoq4+rJdpeW/3q+DI1I=";
  };

  patches = [
    # clang no longer allows using -Ofast
    # see: https://github.com/codam-coding-college/MLX42/issues/147
    (fetchpatch {
      name = "replace-ofast-with-o3.patch";
      url = "https://github.com/codam-coding-college/MLX42/commit/ce254c3a19af8176787601a2ac3490100a5c4c61.patch";
      hash = "sha256-urL/WVOXinf7hWR5kH+bAVTcAzldkkWfY0+diSf7jHE=";
    })
  ];

  postPatch = ''
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
