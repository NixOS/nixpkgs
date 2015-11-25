{ stdenv, fetchFromGitHub, cmake, libX11, procps, python, qt5 }:

let version = "7.1"; in
stdenv.mkDerivation {
  name = "apitrace-${version}";

  src = fetchFromGitHub {
    sha256 = "1n2gmsjnpyam7isg7n1ksggyh6y1l8drvx0a93bnvbcskr7jiz9a";
    rev = version;
    repo = "apitrace";
    owner = "apitrace";
  };

  buildInputs = [ libX11 procps python qt5.base ];
  nativeBuildInputs = [ cmake ];

  buildPhase = ''
    cmake
    make
  '';

  meta = with stdenv.lib; {
    inherit version;
    homepage = https://apitrace.github.io;
    description = "Tools to trace OpenGL, OpenGL ES, Direct3D, and DirectDraw APIs";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
