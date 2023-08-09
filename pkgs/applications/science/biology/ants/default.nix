{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, itk, vtk, Cocoa }:

stdenv.mkDerivation rec {
  pname = "ANTs";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "ANTsX";
    repo = "ANTs";
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
