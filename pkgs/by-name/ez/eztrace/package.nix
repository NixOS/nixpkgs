{
  lib,
  stdenv,
  fetchFromGitLab,
  gfortran,
  libelf,
  libiberty,
  zlib,
  otf2,
  libbfd,
  libopcodes,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "EZTrace";
  version = "2.1.1";

  src = fetchFromGitLab {
    owner = "eztrace";
    repo = "eztrace";
    tag = version;
    hash = "sha256-ccW4YjEf++tkdIJLze2x8B/SWbBBXnYt8UV9OH8+KGU=";
  };

  nativeBuildInputs = [
    gfortran
    cmake
  ];
  buildInputs = [
    libelf
    libiberty
    zlib
    otf2
    libbfd
    libopcodes
  ];

  meta = with lib; {
    description = "Tool that aims at generating automatically execution trace from HPC programs";
    license = licenses.cecill-b;
    maintainers = [ ];
  };
}
