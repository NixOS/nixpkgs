{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, libX11
, libGL
, libGLU
, freeglut }:

stdenv.mkDerivation rec {
  pname = "antiprism";
  version = "0.29";

  src = fetchFromGitHub {
    owner = "antiprism";
    repo = pname;
    rev = version;
    sha256 = "sha256-MHzetkmRDLBXq3KrfXmUhxURY60/Y8z5zQsExT6N4cY=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libX11 libGLU libGL.dev freeglut.dev ];

  meta = with lib; {
    homepage = "https://www.antiprism.com";
    description = "A collection of programs for generating, manipulating, transforming and viewing polyhedra";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
