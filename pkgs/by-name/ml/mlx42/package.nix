{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, glfw
, darwin
, enableShared ? !stdenv.hostPlatform.isStatic
, enableDebug ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mlx42";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "codam-coding-college";
    repo = "MLX42";
    rev = "v${finalAttrs.version}";
    hash = "sha256-igkTeOnqGYBISzmtDGlDx9cGJjoQ8fzXtVSR9hU4F5E=";
  };

  postPatch = ''
    patchShebangs ./tools
  ''
  + lib.optionalString enableShared ''
    substituteInPlace CMakeLists.txt \
        --replace "mlx42 STATIC" "mlx42 SHARED"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ glfw ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ OpenGL Cocoa IOKit ]);

  cmakeFlags = [ "-DDEBUG=${toString enableDebug}" ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./mlx42.pc} $out/lib/pkgconfig/mlx42.pc
  '';

  meta = {
    changelog = "https://github.com/codam-coding-college/MLX42/releases/tag/${finalAttrs.src.rev}";
    description = "A simple cross-platform graphics library that uses GLFW and OpenGL";
    homepage = "https://github.com/codam-coding-college/MLX42";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
})
