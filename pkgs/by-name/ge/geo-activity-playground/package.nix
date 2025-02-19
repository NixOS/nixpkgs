{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "geo-activity-playground";
  version = "0.38.0";
  pyproject = true;
  src = fetchFromGitHub {
    repo = "geo-activity-playground";
    owner = "martin-ueding";
    tag = version;
    hash = "sha256-IUayhNHCIBJbXjRsYeTxZICaMoP/p8eGfTQp2uYh1dI=";
  };

  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];
  pythonRelaxDeps = [
    "pyarrow"
    "numpy"
  ];
  build-system = [ python3.pkgs.poetry-core ];
  dependencies = with python3.pkgs; [
    shapely
    coloredlogs
    geojson
    matplotlib
    pandas
    scipy
    tqdm
    requests
    fitdecode
    gpxpy
    stravalib
    flask
    altair
    tcxreader
    pyarrow
    vegafusion
    vl-convert-python
    xmltodict
    appdirs
    imagehash
  ];

  meta = {
    description = "Data analysis and visualization based on GPS tracked outdoor activities";
    homepage = "https://martin-ueding.github.io/geo-activity-playground/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
    mainProgram = "geo-activity-playground";
  };
}
