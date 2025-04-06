{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "glbinding";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "cginternals";
    repo = "glbinding";
    rev = "v${version}";
    sha256 = "sha256-EHvudihHL/MEVo0lbSqxrgc6TJnPH8Ia6bCJK0yNCbg=";
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
