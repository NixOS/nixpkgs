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
  version = "1.1";
  src = fetchFromGitHub {
    owner = "zeux";
    repo = "meshoptimizer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tvVMg3RO1T1/Ub/uue1UQwYeSwqq9OQ1F3PKlF3YOrk=";
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
