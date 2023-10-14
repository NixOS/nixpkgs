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
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "codam-coding-college";
    repo = "MLX42";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-JCBV8NWibSugqXkbgP0v3gDfaaMNFYztWpBRfHJUG8E=";
  };

  patches = [
    (fetchpatch {
      name = "add-cmake-install.patch";
      url = "https://github.com/codam-coding-college/MLX42/commit/a51ca8e0ec3fb793fa96d710696dcee8a4fe57d6.patch";
      hash = "sha256-i+0yHZVvfTG19BGVrz7GuEuBw3B7lylCPEvx07il23M=";
    })
  ];

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

    # This file was removed after 2.3.2, so the used patch doesn't copy this file
    # This line can be removed after the next release
    cp $src/include/MLX42/MLX42_Input.h $out/include/MLX42
  '';

  meta = {
    description = "A simple cross-platform graphics library that uses GLFW and OpenGL";
    homepage = "https://github.com/codam-coding-college/MLX42";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
})
