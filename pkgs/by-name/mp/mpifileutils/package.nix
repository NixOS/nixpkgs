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
  libcap,
  python3,
  bzip2,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpifileutils";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = "mpifileutils";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OOuL51+NC13vae67wA94OWA6XJGDIwz9WtEMCNn0ptQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    mpi
  ];
  buildInputs = [
    attr
    dtcmp
    libarchive
    libcircle
    libcap
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
