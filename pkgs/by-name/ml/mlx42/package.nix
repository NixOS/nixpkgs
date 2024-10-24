{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glfw,
  darwin,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableDebug ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mlx42";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "codam-coding-college";
    repo = "MLX42";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-jYcBvvx0Xfc/wDWSUROfQeRvn+tWvSS0ymKO1iuzg8w=";
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

  buildInputs =
    [ glfw ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        OpenGL
        Cocoa
        IOKit
      ]
    );

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
