{ lib
, python3
, fetchFromGitLab
}:

python3.pkgs.buildPythonApplication rec {
  pname = "annextimelog";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "nobodyinperson";
    repo = "annextimelog";
    rev = "v${version}";
    hash = "sha256-Q87SmzGaZ2rx+tsOgJIdxHaXK3Kda3jCkgH5y4wvLKE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    rich
  ];

  meta = with lib; {
    description = "️Git Annex-backed Time Tracking";
    homepage = "https://gitlab.com/nobodyinperson/annextimelog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

