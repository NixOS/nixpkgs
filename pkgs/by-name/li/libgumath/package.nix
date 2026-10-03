{
  lib,
  stdenv,
  fetchFromGitHub,
  libndtypes,
  libxnd,
}:

stdenv.mkDerivation {
  pname = "libgumath";
  version = "unstable-2019-08-01";

  src = fetchFromGitHub {
    owner = "xnd-project";
    repo = "libgumath";
    rev = "360ed454105ac5615a7cb7d216ad25bc4181b876";
    hash = "sha256-hnVdn7IMmHKPT0Bo3CybeMuTQ8ErI35dMmNmWW+f+fI=";
  };

  buildInputs = [
    libndtypes
    libxnd
  ];

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  doCheck = true;

  meta = {
    description = "Library supporting function dispatch on general data containers. C base and Python wrapper";
    homepage = "https://xnd.io/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.costrouc ];
  };
}
