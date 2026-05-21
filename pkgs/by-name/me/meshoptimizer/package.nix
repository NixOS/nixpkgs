{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libwebp,
  nix-update-script,
}:

let
  basis_universal = fetchFromGitHub {
    owner = "zeux";
    repo = "basis_universal";
    rev = "88e813c46b3ff42e56ef947b3fa11eeee7a504b0";
    hash = "sha256-8SQhORPPLBeynlRWjpkXxleo5pgkNmEIjcXbptuo8es=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "meshoptimizer";
  version = "1.1.1";
  src = fetchFromGitHub {
    owner = "zeux";
    repo = "meshoptimizer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h5lO3HHPtGYuzAZlRwXugvCsjtSMj9j2Z7xCRHQU8xY=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  cmakeFlags = [
    "-DMESHOPT_BUILD_GLTFPACK=ON"
    "-DMESHOPT_GLTFPACK_BASISU_PATH=${basis_universal}"
    "-DMESHOPT_GLTFPACK_LIBWEBP_PATH=${libwebp.src}"
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
