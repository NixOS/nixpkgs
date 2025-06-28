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
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "ANTsX";
    repo = "ANTs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TQR3HghaFBBiHl5oz3vmu7DIGT8UY5/CxY0pP0bLZx4=";
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
