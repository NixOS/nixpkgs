{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  srcOnly,
  cmake,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "wibo";
  version = "0.6.14";

  src = fetchFromGitHub {
    owner = "decompals";
    repo = "wibo";
    rev = version;
    hash = "sha256-6YcraHBFWmm8TBfuFHbM9jGvUm9KvTOplJrFSTQkt70=";
  };

  nativeBuildInputs = [
    cmake
    unzip
  ];

  doCheck = false;
  # Test step from https://github.com/decompals/wibo/blob/main/.github/workflows/ci.yml
  checkPhase =
    let
      gc = srcOnly {
        name = "GC_WII_COMPILERS";
        src = fetchzip {
          url = "https://files.decomp.dev/compilers_20230715.zip";
          hash = "sha256-IX3byvEUVJB6Rmc+NqO9ZNt1jl95nQpEIqxbHI+uUio=";
          stripRoot = false;
        };
        meta.license = lib.licenses.unfree;
      };
    in
    lib.optionalString doCheck ''
      MWCIncludes=../test ./wibo ${gc}/GC/2.7/mwcceppc.exe -c ../test/test.c
      file test.o | grep "ELF 32-bit"
    '';

  meta = with lib; {
    description = "Quick-and-dirty wrapper to run 32-bit windows EXEs on linux";
    longDescription = ''
      A minimal, low-fuss wrapper that can run really simple command-line
      32-bit Windows binaries on Linux - with less faff and less dependencies
      than WINE.
    '';
    homepage = "https://github.com/decompals/WiBo";
    license = licenses.mit;
    maintainers = with maintainers; [ r-burns ];
    platforms = [ "i686-linux" ];
    mainProgram = "wibo";
  };
}
