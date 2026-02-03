{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "polysh";
  version = "1.0.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "innogames";
    repo = "polysh";
    rev = "polysh-${version}";
    hash = "sha256-fmcu3lWSV5aft+gX5QjypdK5pyfdVd0HDNekiFVdlBI=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  meta = {
    description = "Remote shell multiplexer for executing commands on multiple hosts";
    homepage = "https://github.com/innogames/polysh";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ seqizz ];
    platforms = lib.platforms.unix;
  };
}
