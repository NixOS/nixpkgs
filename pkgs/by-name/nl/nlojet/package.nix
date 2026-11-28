{
  lib,
  stdenv,
  fetchFromGitLab,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "nlojet++";
  version = "4.1.3";

  src = fetchFromGitLab {
    owner = "NLO";
    repo = "nlojetxx";
    rev = version;
    domain = "gitlab.desy.de";
    hash = "sha256-tVWjCX+O1ZtefxtyzKU7hfBodIeFDBRyqAcwLama9YE=";
  };

  env.CXXFLAGS = "-std=c++11";

  meta = {
    homepage = "https://gitlab.desy.de/nlo/nlojetxx";
    license = lib.licenses.gpl2;
    description = "Implementation of calculation of the hadron jet cross sections";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
