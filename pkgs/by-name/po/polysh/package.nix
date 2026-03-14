{
  lib,
  python311Packages,
  fetchFromGitHub,
}:
python311Packages.buildPythonApplication {
  pname = "polysh";
  version = "0.15";

  pyproject = true;

  build-system = with python311Packages; [
    hatchling
  ];

  src = fetchFromGitHub {
    owner = "innogames";
    repo = "polysh";
    rev = "polysh-0.15";
    hash = "sha256-+GfjFrh9S0+2SoxradflGWsGV9p6GCKmdnBNLW8OKNA=";
  };

  meta = with lib; {
    description = "Remote shell multiplexer for executing commands on multiple hosts";
    homepage = "https://github.com/innogames/polysh";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ seqizz ];
    platforms = platforms.unix;
  };
}
