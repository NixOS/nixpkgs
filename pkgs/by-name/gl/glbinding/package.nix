{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "glbinding";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "cginternals";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xmEXZ1ssXzrElqd6D1zooFxLEyspsF4Dau3d9+1/2yw=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGLU ];

  meta = {
    homepage = "https://github.com/cginternals/glbinding/";
    description = "C++ binding for the OpenGL API, generated using the gl.xml specification";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mt-caret ];
  };
}
