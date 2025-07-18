{
  fetchFromGitHub,
  python3,
  fetchurl,
  autoPatchelfHook,
  stdenv,
  lib,
}:
let
  pyarrow-wheel = {
    "x86_64-linux" = {
      url = "https://files.pythonhosted.org/packages/27/2e/29bb28a7102a6f71026a9d70d1d61df926887e36ec797f2e6acfd2dd3867/pyarrow-19.0.1-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-tMQVamJfHjXWwLITJjWiN3CJROtB31++fVDyDSDBeDI=";
    };
    "aarch64-linux" = {
      url = "https://files.pythonhosted.org/packages/fe/4f/a2c0ed309167ef436674782dfee4a124570ba64299c551e38d3fdaf0a17b/pyarrow-19.0.1-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-04NZHz3L5UX2zGLarvnHzf4N/w+54cgSEQHKvpCYz6Y=";
    };
  };

  python3' = python3.override {
    packageOverrides = self: _: {
      pyarrow = self.buildPythonPackage {
        pname = "pyarrow";
        version = "19.0.1";

        src = fetchurl pyarrow-wheel.${stdenv.system};
        format = "wheel";

        nativeBuildInputs = [ autoPatchelfHook ];

        pythonImportsCheck = [
          "pyarrow"
        ];
      };
    };
  };

  python3Packages = python3'.pkgs;
in
python3Packages.buildPythonPackage rec {
  pname = "garmin-grafana";
  version = "0.2.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "arpanghosh8453";
    repo = "garmin-grafana";
    rev = "v${version}";
    hash = "sha256-m6gKZ0uMS/KhDu/y8e+cx//4f32FgdNfUF3+l6of5OY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    python-dotenv
    fitparse
    garminconnect
    influxdb
    influxdb3-python
  ];

  doCheck = false; # there are no tests

  dontCheckRuntimeDeps = true;

  passthru.grafana-dashboard = "${src}/Grafana_Dashboard/Garmin-Grafana-Dashboard.json"; # can be provisioned to Grafana

  meta = {
    description = "Export Garmin data to InfluxDB";
    longDescription = ''
      A Python script to fetch Garmin health data and populate that in an InfluxDB database,
      for visualizing long-term health trends with Grafana
    '';
    homepage = "https://github.com/arpanghosh8453/garmin-grafana";
    changelog = "https://github.com/arpanghosh8453/garmin-grafana/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aciceri ];
    mainProgram = "garmin-fetch";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
