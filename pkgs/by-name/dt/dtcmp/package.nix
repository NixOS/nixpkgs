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

<<<<<<< HEAD
  meta = {
    description = "MPI datatype comparison library";
    homepage = "https://github.com/LLNL/dtcmp";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
=======
  meta = with lib; {
    description = "MPI datatype comparison library";
    homepage = "https://github.com/LLNL/dtcmp";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
