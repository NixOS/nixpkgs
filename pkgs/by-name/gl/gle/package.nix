{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libglut,
  libx11,
  libxt,
  libxmu,
  libxi,
  libxext,
  libGL,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "gle";
  version = "3.1.2";

  buildInputs = [
    libGLU
    libGL
    libglut
    libx11
    libxt
    libxmu
    libxi
    libxext
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  src = fetchFromGitHub {
    owner = "linas";
    repo = "glextrusion";
    tag = "${pname}-${version}";
    sha256 = "sha256-yvCu0EOwxOMN6upeHX+C2sIz1YVjjB/320g+Mf24S6g=";
  };

  meta = {
    description = "Tubing and extrusion library";
    homepage = "https://www.linas.org/gle/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
