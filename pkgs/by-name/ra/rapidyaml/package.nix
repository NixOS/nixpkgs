{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  git,
}:

stdenv.mkDerivation rec {
  pname = "rapidyaml";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    hash = "sha256-vAYafhWo9xavM2j+mT3OGcX7ZSS25mieR/3b79BO+jA=";
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
