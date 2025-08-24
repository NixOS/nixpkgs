{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  git,
}:

stdenv.mkDerivation rec {
  pname = "rapidyaml";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = "rapidyaml";
    fetchSubmodules = true;
    tag = "v${version}";
    hash = "sha256-+ENfflVjeesX14m0G71HdeSIECopZV4J2JL9+c+nbXE=";
  };

  nativeBuildInputs = [
    cmake
    git
  ];

  meta = with lib; {
    description = "Library to parse and emit YAML, and do it fast";
    homepage = "https://github.com/biojppm/rapidyaml";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
