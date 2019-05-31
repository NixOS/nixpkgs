{ stdenv, fetchFromGitHub, cmake, makeWrapper, itk, vtk }:

stdenv.mkDerivation rec {
  _name    = "ANTs";
  _version = "2.2.0";
  name  = "${_name}-${_version}";

  src = fetchFromGitHub {
    owner  = "ANTsX";
    repo   = "ANTs";
    rev    = "37ad4e20be3a5ecd26c2e4e41b49e778a0246c3d";
    sha256 = "1hrdwv3m9xh3yf7l0rm2ggxc2xzckfb8srs88g485ibfszx7i03q";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ itk vtk ];

  cmakeFlags = [ "-DANTS_SUPERBUILD=FALSE" "-DUSE_VTK=TRUE" ];

  enableParallelBuilding = true;

  postInstall = ''
    for file in $out/bin/*; do
      wrapProgram $file --set ANTSPATH "$out/bin"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ANTxS/ANTs;
    description = "Advanced normalization toolkit for medical image registration and other processing";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
