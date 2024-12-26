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
    repo = "gumath";
    rev = "360ed454105ac5615a7cb7d216ad25bc4181b876";
    sha256 = "1wprkxpmjrk369fpw8rbq51r7jvqkcndqs209y7p560cnagmsxc6";
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

  meta = with lib; {
    description = "Library supporting function dispatch on general data containers. C base and Python wrapper";
    homepage = "https://xnd.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
