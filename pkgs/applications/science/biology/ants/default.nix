{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeBinaryWrapper,
  itk,
  vtk,
  Cocoa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ANTs";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "ANTsX";
    repo = "ANTs";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-DZzuHMC0XymFCnDn+H1pRFx9jUt+s03PaN88R4ZBRwY=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];

  buildInputs =
    [
      itk
      vtk
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Cocoa
    ];

  cmakeFlags = [
    "-DANTS_SUPERBUILD=FALSE"
    "-DUSE_VTK=TRUE"
  ];

  postInstall = ''
    for file in $out/bin/*; do
      wrapProgram $file --set PATH "$out/bin"
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
