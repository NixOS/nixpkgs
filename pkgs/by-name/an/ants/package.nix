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
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "ANTsX";
    repo = "ANTs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H/5X6cCjv+7KuZGJ7D4d5VxlpOqbO80U+7CoYnY/dsU=";
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
