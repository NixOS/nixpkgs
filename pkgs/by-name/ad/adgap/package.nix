{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "adgap";
  version = "0-unstable-2024-06-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AlexandreDecan";
    repo = "gap";
    rev = "ae33cfd82779e06327e8178edf4946c8ec2ab92c";
    hash = "sha256-Tcc22ohYFaZlhUpeKZxVz6s/LvDVNUI5Iz5ufIHJCco=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    dateutil
    gitpython
    python-dateutil
    scipy
    pandas
    plotnine
  ];

  postInstall = ''
    mv $out/bin/gap $out/bin/adgap
  '';

  pythonImportsCheck = [ "gap" ];

  meta = {
    description = "GAP: Forecasting Commit Activity in git Projects";
    homepage = "https://github.com/AlexandreDecan/gap";
    license = lib.licenses.gpl3Only;
    mainProgram = "adgap";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
