<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, cmake
, makeBinaryWrapper
, itk
, vtk
, Cocoa
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ANTs";
  version = "2.5.0";
=======
{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, itk, vtk, Cocoa }:

stdenv.mkDerivation rec {
  pname = "ANTs";
  version = "2.4.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ANTsX";
    repo = "ANTs";
<<<<<<< HEAD
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-rSibcsprhMC1qsuZN8ou32QPLf8n62BiDzpnTRWRx0Q=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];

  buildInputs = [
    itk
    vtk
  ] ++ lib.optionals stdenv.isDarwin [
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
=======
    rev = "refs/tags/v${version}";
    hash = "sha256-GQndI8ayBvqujb2/qXT6RBAfr8hNPCI5IbwYkPlyNg0=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ itk vtk ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  cmakeFlags = [ "-DANTS_SUPERBUILD=FALSE" "-DUSE_VTK=TRUE" ];

  postInstall = ''
    for file in $out/bin/*; do
      wrapProgram $file --set ANTSPATH "$out/bin"
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/ANTsX/ANTs";
    description = "Advanced normalization toolkit for medical image registration and other processing";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
