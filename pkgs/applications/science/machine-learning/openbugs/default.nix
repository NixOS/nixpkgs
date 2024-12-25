{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "OpenBUGS";
  version = "3.2.3";

  outputs = [ "out" ];

  src = fetchFromGitHub {
    owner = "jsta";
    repo = "openbugs";
    rev = "cd921342ba13ee89ee60f9aebd2e96c42bd59ae3";
    sha256 = "sha256-11LrScN1kvtq0Fo7RWGjbQO0U5b5brCbipl5pdZnrFs=";
  };

  meta = with lib; {
    description = "Software package for performing Bayesian analysis and simulation using Markov Chain Monte Carlo";
    homepage = "https://www.mrc-bsu.cam.ac.uk/software/bugs/openbugs/";
    changelog = "https://github.com/jsta/openbugs/blob/master/ChangeLog";
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ andresnav ];
  };
}
