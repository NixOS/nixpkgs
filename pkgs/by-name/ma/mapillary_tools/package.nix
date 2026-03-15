{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mapillary-tools";
  version = "0.14.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mapillary";
    repo = "mapillary_tools";
    rev = "v${version}";
    hash = "sha256-V9Ear1yYy+yf0pdICDylBAA+hCz9aWDuPuIqRV4qEUQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "jsonschema"
  ];

  dependencies = with python3Packages; [
    appdirs
    construct
    exifread
    gpxpy
    humanize
    jsonschema
    piexif
    pynmea2
    pysocks
    requests
    tqdm
    typing-extensions
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pillow
  ];

  pythonImportsCheck = [ "mapillary_tools" ];

  meta = {
    description = "Command line tool for processing and uploading Mapillary imagery";
    homepage = "https://github.com/mapillary/mapillary_tools";
    downloadPage = "https://github.com/mapillary/mapillary_tools/releases/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ StrangeGirlMurph ];
    platforms = lib.platforms.all;
    mainProgram = "mapillary_tools";
  };
}
