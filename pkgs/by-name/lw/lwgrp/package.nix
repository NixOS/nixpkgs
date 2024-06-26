{
  lib,
  stdenv,
  fetchFromGitHub,
  mpi,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "lwgrp";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "lwgrp";
    rev = "v${version}";
    hash = "sha256-f0tYn9FbrOz8iMoG8Is8vYDNfYHTfxLKNnyxJA+Msdk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  propagatedBuildInputs = [ mpi ];

  meta = with lib; {
    description = "Data structures and operations to group MPI processes as an ordered set";
    homepage = "https://github.com/LLNL/lwgrp";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
  };
}
