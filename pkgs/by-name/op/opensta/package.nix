{ lib
, fetchFromGitHub
, stdenv

, # dependencies
  cmake
, flex
, bison
, swig
, zlib
, tcl
}:

let
  version = "2.2.0";
in
stdenv.mkDerivation {
  pname = "opensta";
  inherit version;

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenSTA";
    rev = "v${version}";
    hash = "sha256-qKcTEtFdZM/VKFbo6ldoXfJgHsS2JMf+9IfrPja5GLw=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_package(SWIG REQUIRED 3.0)' 'find_package(SWIG)'
  '';

  nativeBuildInputs = [ cmake flex bison swig ];
  buildInputs = [ zlib tcl ];

  meta = {
    description = "A gate level static timing verifier";
    homepage = "https://github.com/The-OpenROAD-Project/OpenSTA";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
