{
  lib,
  stdenv,
  fetchFromGitHub,
  mpi,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lwgrp";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "lwgrp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZpxxcCqK+qdvnCvobeBV6htRF8wThiQgVFYgEigqmIE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  propagatedBuildInputs = [ mpi ];

  meta = {
    description = "Data structures and operations to group MPI processes as an ordered set";
    homepage = "https://github.com/LLNL/lwgrp";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
