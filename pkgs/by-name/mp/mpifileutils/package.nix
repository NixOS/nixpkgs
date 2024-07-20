{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, mpi
, attr
, dtcmp
, libarchive
, libcircle
, bzip2
, openssl
}:

stdenv.mkDerivation rec {
  pname = "mpifileutils";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = "mpifileutils";
    rev = "v${version}";
    hash = "sha256-3nls82awMMCwlfafsOy3AY8OvT9sE+BvvsDOY14YvQc=";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    attr
    dtcmp
    libarchive
    libcircle
    bzip2
    openssl
  ];

  propagatedBuildInputs = [ mpi ];

  meta = with lib; {
    description = "Suite of MPI-based tools to manage large datasets";
    homepage = "https://hpc.github.io/mpifileutils";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
  };
}
