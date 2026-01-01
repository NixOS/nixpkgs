{
  lib,
  borgmatic,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "prometheus-borgmatic-exporter";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxim-mityutko";
    repo = "borgmatic-exporter";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-fhsGpQolZxX5VAAEV3hiLF7bo4pbVt9GWyertf2oeO0=";
=======
    hash = "sha256-QbpHSpcXJdmi6oiPTFT6XwNLtaXSAGavHeEoz3IV73I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
