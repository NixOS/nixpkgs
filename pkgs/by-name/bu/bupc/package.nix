{
  lib,
  stdenv,
  fetchurl,
  perl,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "berkeley_upc";
  version = "2020.12.0";

  src = fetchurl {
    url = "http://upc.lbl.gov/download/release/berkeley_upc-${version}.tar.gz";
    hash = "sha256-JdpFORlXHpCQE+TivoQQnjQlxQN7C8BNfHvTOSwXbYQ=";
  };

  postPatch = ''
    patchShebangs .
  '';

  # Used during the configure phase
  ENVCMD = "${coreutils}/bin/env";

  buildInputs = [ perl ];

  meta = with lib; {
    description = "Compiler for the Berkely Unified Parallel C language";
    longDescription = ''
      Unified Parallel C (UPC) is an extension of the C programming language
      designed for high performance computing on large-scale parallel
      machines.The language provides a uniform programming model for both
      shared and distributed memory hardware. The programmer is presented with
      a single shared, partitioned address space, where variables may be
      directly read and written by any processor, but each variable is
      physically associated with a single processor. UPC uses a Single Program
      Multiple Data (SPMD) model of computation in which the amount of
      parallelism is fixed at program startup time, typically with a single
      thread of execution per processor.
    '';
    homepage = "https://upc.lbl.gov/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zimbatm ];
  };
}
