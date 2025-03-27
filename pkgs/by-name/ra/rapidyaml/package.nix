{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  git,
}:

stdenv.mkDerivation rec {
  pname = "rapidyaml";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = "rapidyaml";
    fetchSubmodules = true;
    rev = "v${version}";
    hash = "sha256-5Z1UV8JSgaO4X8+fTEgxD7bzD1igOgiLQMn10c3rCLs=";
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
