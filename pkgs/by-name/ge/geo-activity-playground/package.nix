{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "geo-activity-playground";
  version = "0.24.2";
  format = "pyproject";
  src = fetchFromGitHub {
    repo = "geo-activity-playground";
    owner = "martin-ueding";
    rev = version;
    hash = "sha256-kJmaIUjEjW+hu6W/yS19QCZm/ZNbbr5X6F2UWPru4M8=";
  };
  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "pyarrow" ];
  propagatedBuildInputs = with python3.pkgs; [
    shapely
    poetry-core
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
    description = "Data analysis and visualization based on GPS tracked outdoor activities.";
    homepage = "https://github.com/martin-ueding/geo-activity-playground";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
    mainProgram = "geo-activity-playground";
  };
}
