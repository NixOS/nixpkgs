{ stdenv, fetchFromGitHub, cmake, libX11, procps, python, qt5 }:

let version = "7.0"; in
stdenv.mkDerivation {
  name = "apitrace-${version}";

  src = fetchFromGitHub {
    sha256 = "0nn3z7i6cd4zkmms6jpp1v2q194gclbs06v0f5hyiwcsqaxzsg5b";
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
