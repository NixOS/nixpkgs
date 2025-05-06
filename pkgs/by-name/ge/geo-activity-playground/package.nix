{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "geo-activity-playground";
  version = "0.38.2";
  src = fetchFromGitHub {
    repo = "geo-activity-playground";
    owner = "martin-ueding";
    tag = version;
    hash = "sha256-L4o4z659u0xrOmck/FLhZ694G7UdPzLDofjMumDGNog=";
  };
  pyproject = true;

  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];
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
  pythonRelaxDeps = [
    "matplotlib"
    "xmltodict"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Data analysis and visualization based on GPS tracked outdoor activities";
    homepage = "https://martin-ueding.github.io/geo-activity-playground/";
    changelog = "https://martin-ueding.github.io/geo-activity-playground/reference/changelog/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
    mainProgram = "geo-activity-playground";
  };
}
