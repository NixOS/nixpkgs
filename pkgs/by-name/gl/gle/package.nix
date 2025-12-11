{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libglut,
  libX11,
  libXt,
  libXmu,
  libXi,
  libXext,
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
    libX11
    libXt
    libXmu
    libXi
    libXext
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  src = fetchFromGitHub {
    owner = "linas";
    repo = "glextrusion";
    rev = "refs/tags/${pname}-${version}";
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
