{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeBinaryWrapper,
  itk,
  vtk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ANTs";
<<<<<<< HEAD
  version = "2.6.4";
=======
  version = "2.6.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ANTsX";
    repo = "ANTs";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-c2a73OpRE/kCq8gq2DlwTQVZdTfKBuUQN/VeOZEkGIc=";
=======
    hash = "sha256-AaurwFIDVKhAp8+Gu3TUlGJP33ChQ6flPTYWe/cVK0w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];

  buildInputs = [
    itk
    vtk
  ];

  cmakeFlags = [
    "-DANTS_SUPERBUILD=FALSE"
    "-DUSE_VTK=TRUE"
  ];

  postInstall = ''
    for file in $out/bin/*; do
      wrapProgram $file --prefix PATH : "$out/bin"
    done
  '';

  meta = {
    changelog = "https://github.com/ANTsX/ANTs/releases/tag/v${finalAttrs.version}";
    description = "Advanced normalization toolkit for medical image registration and other processing";
    homepage = "https://github.com/ANTsX/ANTs";
    license = lib.licenses.asl20;
    mainProgram = "antsRegistration";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
  };
})
