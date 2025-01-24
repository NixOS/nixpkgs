{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  python3,
  bison,
  flex,
  libxml2,
  openjdk,
  ncbi-vdb,
  mbedtls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sratoolkit";

  # NOTE: When updating make sure to update ncbi-vdb as well for versions to match
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "ncbi";
    repo = "sra-tools";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-WVPiAz3EFYuhBnl7BsEjJ2BTi1wAownEunVM4sdLaj8=";
  };

  cmakeFlags = [
    "-DVDB_INCDIR=${ncbi-vdb}/include"
    "-DVDB_LIBDIR=${ncbi-vdb}/lib"
  ];

  buildInputs = [
    ncbi-vdb
    libxml2
    mbedtls
  ];

  nativeBuildInputs = [
    cmake
    python3
    bison
    flex
    openjdk
  ];

  meta = {
    homepage = "https://github.com/ncbi/sra-tools";
    description = "Collection of tools and libraries for using data in the INSDC Sequence Read Archives";
    license = lib.licenses.ncbiPd;
    maintainers = with lib.maintainers; [
      thyol
      t4ccer
    ];
    platforms = lib.platforms.unix;
  };
})
