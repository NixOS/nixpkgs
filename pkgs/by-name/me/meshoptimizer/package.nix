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
stdenv.mkDerivation rec {
  pname = "meshoptimizer";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "0.25";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "zeux";
    repo = "meshoptimizer";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-t5cWeGf9YI9oG919c6mdXE+qnK2rkTLW0GJ52vw/HrI=";
=======
    hash = "sha256-ac1qX7neAN5Okpe3EytZKOglesyAAnyQkNWXa7TnMcg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Mesh optimization library that makes meshes smaller and faster to render";
    homepage = "https://github.com/zeux/meshoptimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bouk
      lillycham
    ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Mesh optimization library that makes meshes smaller and faster to render";
    homepage = "https://github.com/zeux/meshoptimizer";
    license = licenses.mit;
    maintainers = with maintainers; [
      bouk
      lillycham
    ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gltfpack";
  };
}
