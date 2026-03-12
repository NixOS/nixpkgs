{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

let
  basis_universal = fetchFromGitHub {
    owner = "zeux";
    repo = "basis_universal";
    rev = "8903f6d69849fd782b72a551a4dd04a264434e20";
    hash = "sha256-o3dCxAAkpMoNkvkM7qD75cPn/obDc/fJ8u7KLPm1G6g=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "meshoptimizer";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "zeux";
    repo = "meshoptimizer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-t5cWeGf9YI9oG919c6mdXE+qnK2rkTLW0GJ52vw/HrI=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  cmakeFlags = [
    "-DMESHOPT_BUILD_GLTFPACK=ON"
    "-DMESHOPT_BASISU_PATH=${basis_universal}"
  ]
  ++ lib.optional (!stdenv.hostPlatform.isStatic) "-DMESHOPT_BUILD_SHARED_LIBS:BOOL=ON";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mesh optimization library that makes meshes smaller and faster to render";
    homepage = "https://github.com/zeux/meshoptimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bouk
      lillycham
    ];
    platforms = lib.platforms.all;
    mainProgram = "gltfpack";
  };
})
