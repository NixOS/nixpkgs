{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  git,
}:

stdenv.mkDerivation rec {
  pname = "rapidyaml";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = "rapidyaml";
    fetchSubmodules = true;
    tag = "v${version}";
    hash = "sha256-r19PBS35mvAK2RoZGXaw6UU9EuEXVoUK6BV6cJnPyUs=";
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
