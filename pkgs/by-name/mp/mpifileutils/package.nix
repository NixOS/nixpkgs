{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  mpi,
  attr,
  dtcmp,
  libarchive,
  libcircle,
  bzip2,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpifileutils";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = "mpifileutils";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WnjStOLWP/VsZyl2wPqR1Q+YqlJQRCQ4R50uOyqkWuM=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    attr
    dtcmp
    libarchive
    libcircle
    bzip2
    openssl
  ];

  propagatedBuildInputs = [ mpi ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Suite of MPI-based tools to manage large datasets";
    homepage = "https://hpc.github.io/mpifileutils";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
