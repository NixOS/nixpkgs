{ lib
, stdenv
, fetchFromGitHub
, cmake
, makeBinaryWrapper
, itk
, vtk
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "ANTs";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "ANTsX";
    repo = "ANTs";
    rev = "refs/tags/v${version}";
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
      wrapProgram $file --set ANTSPATH "$out/bin"
    done
  '';

  meta = {
    description = "Advanced normalization toolkit for medical image registration and other processing";
    homepage = "https://github.com/ANTsX/ANTs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
  };
}
