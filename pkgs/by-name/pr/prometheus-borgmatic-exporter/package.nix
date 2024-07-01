{ lib, fetchFromGitHub, python3Packages, borgmatic }:
python3Packages.buildPythonApplication rec {
  pname = "prometheus-borgmatic-exporter";
  version = "0.2.3";

  format = "pyproject";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "maxim-mityutko";
    repo = "borgmatic-exporter";
    sha256 = "sha256-FnjC7TOE9g/nQbQ3N0Luw0PLnG4wH4MG0A1JasPpW6M=";
  };

  patches = [ ./fix-poetry-packaging.patch ./broaden-version-pins.patch ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook pytest-mock ];

  propagatedBuildInputs = [ borgmatic ] ++ (with python3Packages; [
    poetry-core
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
    platforms = platforms.unix;
  };
}
