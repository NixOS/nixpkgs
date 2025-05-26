{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "glbinding";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "cginternals";
    repo = "glbinding";
    rev = "v${version}";
    sha256 = "sha256-oLtOsiXfl/18rY/89vl9JDDWpPmEELOFKAHuClveU0c=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGLU ];

  meta = with lib; {
    homepage = "https://github.com/cginternals/glbinding/";
    description = "C++ binding for the OpenGL API, generated using the gl.xml specification";
    license = licenses.mit;
    maintainers = [ maintainers.mt-caret ];
  };
}
