{ stdenv, fetchFromGitHub, cmake, makeWrapper, itk, vtk }:

stdenv.mkDerivation rec {
  _name    = "ANTs";
  _version = "2.1.0";
  name  = "${_name}-${_version}";

  src = fetchFromGitHub {
    owner  = "stnava";
    repo   = "ANTs";
    rev    = "4e02aa76621698e3513330dd9e863e22917e14b7";
    sha256 = "0gyys1lf69bl3569cskxc8r5llwcr0dsyzvlby5skhfpsyw0dh8r";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ itk vtk ];

  cmakeFlags = [ "-DANTS_SUPERBUILD=FALSE" "-DUSE_VTK=TRUE" ];

  checkPhase = "ctest";
  doCheck = false;

  postInstall = ''
    for file in $out/bin/*; do
      wrapProgram $file --set ANTSPATH "$out/bin"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/stnava/ANTs;
    description = "Advanced normalization toolkit for medical image registration and other processing";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
