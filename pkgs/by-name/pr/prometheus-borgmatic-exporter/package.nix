{
  lib,
  fetchFromGitHub,
  python3Packages,
  borgmatic,
}:
python3Packages.buildPythonApplication rec {
  pname = "prometheus-borgmatic-exporter";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxim-mityutko";
    repo = "borgmatic-exporter";
    rev = "v${version}";
    hash = "sha256-SgP1utu4Eqs9214pYOT9wP0Ms7AUQH1A3czQF8+qBRo=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
  ];

  buildInputs = [ python3Packages.poetry-core ];

  propagatedBuildInputs =
    [ borgmatic ]
    ++ (with python3Packages; [
      flask
      arrow
      click
      loguru
      pretty-errors
      prometheus-client
      timy
      waitress
    ]);

  meta = with lib; {
    description = "Prometheus exporter for Borgmatic";
    homepage = "https://github.com/maxim-mityutko/borgmatic-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ flandweber ];
    mainProgram = "borgmatic-exporter";
    platforms = platforms.unix;
  };
}
