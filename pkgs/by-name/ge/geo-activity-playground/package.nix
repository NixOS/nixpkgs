{ lib
, python3
, fetchFromGitHub
}:
python3.pkgs.buildPythonApplication rec {
  pname = "geo-activity-playground";
  version = "0.18.0";
  format = "pyproject";
  src = fetchFromGitHub {
    repo = "geo-activity-playground";
    owner = "martin-ueding";
    rev = version;
    hash = "sha256-zYs+Y+n3T3pcC0xo1fTE6/1ueePdTToxM75VkE907KU=";
  };
  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];
  pythonRelaxDeps = [
    "Pillow"
    "flask"
    "pyarrow"
  ];
  propagatedBuildInputs = with python3.pkgs; [
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
  ];

  meta = {
    description = "Data analysis and visualization based on GPS tracked outdoor activities.";
    homepage = "https://github.com/martin-ueding/geo-activity-playground";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
    mainProgram = "geo-activity-playground";
  };
}
