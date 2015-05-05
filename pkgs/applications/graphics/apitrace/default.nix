{ stdenv, fetchFromGitHub, cmake, python, libX11, qt4 }:

let version = "6.1"; in
stdenv.mkDerivation {
  name = "apitrace-${version}";

  src = fetchFromGitHub {
    sha256 = "1v38111ljd35v5sahshs3inhk6nsv7rxh4r0ck8k0njkwzlx2yqk";
    rev = version;
    repo = "apitrace";
    owner = "apitrace";
  };

  buildInputs = [ cmake python libX11 qt4 ];

  buildPhase = ''
    cmake
    make
  '';

  meta = with stdenv.lib; {
    homepage = https://apitrace.github.io;
    description = "Tools to trace OpenGL, OpenGL ES, Direct3D, and DirectDraw APIs";
    license = with licenses; mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
