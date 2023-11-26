{ lib
, python3
, fetchFromGitHub
}:
python3.pkgs.buildPythonApplication rec {
  pname = "geo-activity-playground";
  version = "0.17.5";
  format = "pyproject";
  src = fetchFromGitHub {
    repo = "geo-activity-playground";
    owner = "martin-ueding";
    rev = version;
    hash = "sha256-zyiW54UDUDmQfphztuTGW1i1r0dsgE7Lcr24dKMJMmM=";
  };
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
  ];

  meta = {
    description = "Data analysis and visualization based on GPS tracked outdoor activities.";
    homepage = "https://github.com/martin-ueding/geo-activity-playground";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
    mainProgram = "geo-activity-playground";
  };
}
