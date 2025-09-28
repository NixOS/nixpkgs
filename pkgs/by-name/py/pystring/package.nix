{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "pystring";
  version = "1.1.4-unstable-2025-06-23";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "pystring";
    rev = "02ef1186d6b77bc35f385bd4db2da75b4736adb7";
    hash = "sha256-M0/nDxeRo8NBQ3/SvBc0i5O4ImIP/A8ry/jA27dLybg=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/imageworks/pystring/";
    description = "Collection of C++ functions which match the interface and behavior of python's string class methods using std::string";
    license = licenses.bsd3;
    maintainers = [ maintainers.rytone ];
    platforms = platforms.unix;
  };
}
