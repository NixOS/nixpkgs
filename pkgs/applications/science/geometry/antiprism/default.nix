{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libX11,
  libGL,
  libGLU,
  freeglut,
}:

stdenv.mkDerivation rec {
  pname = "antiprism";
  version = "0.30";

  src = fetchFromGitHub {
    owner = "antiprism";
    repo = pname;
    rev = version;
    sha256 = "sha256-dD3MH+KectuuKOYF7bqWtGsBo5zz+UMyY/io1tgXbgU=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libX11
    libGLU
    libGL.dev
    freeglut.dev
  ];

  meta = with lib; {
    homepage = "https://www.antiprism.com";
    description = "A collection of programs for generating, manipulating, transforming and viewing polyhedra";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
