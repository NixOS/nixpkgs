{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, makeWrapper, itk4, vtk_7, Cocoa }:

stdenv.mkDerivation rec {
  pname    = "ANTs";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner  = "ANTsX";
    repo   = "ANTs";
    rev    = "37ad4e20be3a5ecd26c2e4e41b49e778a0246c3d";
    sha256 = "1hrdwv3m9xh3yf7l0rm2ggxc2xzckfb8srs88g485ibfszx7i03q";
  };

  patches = [
    # Fix build with gcc8
    (fetchpatch {
      url = "https://github.com/ANTsX/ANTs/commit/89af9b2694715bf8204993e032fa132f80cf37bd.patch";
      sha256 = "1glkrwa1jmxxbmzihycxr576azjqby31jwpj165qc54c91pn0ams";
    })
  ];

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ itk4 vtk_7 ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

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
