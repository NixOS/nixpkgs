{
  lib,
  borgmatic,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "prometheus-borgmatic-exporter";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxim-mityutko";
    repo = "borgmatic-exporter";
    tag = "v${version}";
    hash = "sha256-fhsGpQolZxX5VAAEV3hiLF7bo4pbVt9GWyertf2oeO0=";
  };

  pythonRelaxDeps = [ "prometheus-client" ];

  build-system = with python3Packages; [ poetry-core ];

  propagatedBuildInputs = [
    borgmatic
  ]
  ++ (with python3Packages; [
    arrow
    click
    flask
    loguru
    pretty-errors
    prometheus-client
    timy
    waitress
  ]);

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
  ];

  meta = {
    description = "Prometheus exporter for Borgmatic";
    homepage = "https://github.com/maxim-mityutko/borgmatic-exporter";
    changelog = "https://github.com/maxim-mityutko/borgmatic-exporter/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flandweber ];
    mainProgram = "borgmatic-exporter";
    platforms = lib.platforms.unix;
  };
}
