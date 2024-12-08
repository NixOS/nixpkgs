{ lib
, python3
, fetchFromGitLab
}:

python3.pkgs.buildPythonApplication rec {
  pname = "annextimelog";
  version = "0.13.1";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "nobodyinperson";
    repo = "annextimelog";
    rev = "v${version}";
    hash = "sha256-VgeILw8WfqVrmsU/kBw+jHTOt2a6sVT7YgP2pKRp2AY=";
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

