{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  git,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidyaml";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = "rapidyaml";
    fetchSubmodules = true;
    tag = "v${finalAttrs.version}";
    hash = "sha256-GTEgdCxqPs/Xos9pLDa0Zn/3heLBi17bhiNHfChTxQk=";
  };

  nativeBuildInputs = [
    cmake
    git
  ];

  meta = {
    description = "Library to parse and emit YAML, and do it fast";
    homepage = "https://github.com/biojppm/rapidyaml";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
