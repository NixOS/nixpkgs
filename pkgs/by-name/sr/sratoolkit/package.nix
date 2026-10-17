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
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "ncbi";
    repo = "sra-tools";
    tag = finalAttrs.version;
    hash = "sha256-JMdJ8F4n9WgdP2oj8MN1+QlxCSmqFzsjAovx/+RyVjk=";
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
      t4ccer
    ];
    platforms = lib.platforms.unix;
  };
})
