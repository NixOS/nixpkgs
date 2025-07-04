{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  mpi,
  lwgrp,
}:

stdenv.mkDerivation rec {
  pname = "dtcmp";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "dtcmp";
    rev = "v${version}";
    hash = "sha256-Dc+c8JCc5D23CtpwiWkHCqngywEZXw7cYsRiSYiQdWk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ lwgrp ];

  configureFlags = [ "--with-lwgrp=${lib.getDev lwgrp}" ];

  propagatedBuildInputs = [ mpi ];

  meta = with lib; {
    description = "MPI datatype comparison library";
    homepage = "https://github.com/LLNL/dtcmp";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
  };
}
