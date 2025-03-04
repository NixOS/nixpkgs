{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "garmindb";
  version = "3.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tcgoetz";
    repo = "garmindb";
    tag = "v${version}";
    hash = "sha256-JAUDAYf9CH/BxwV88ziF5Zy+3ibcbieEfHrZpHSU8m0=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    sqlalchemy
    python-dateutil
    cached-property
    tqdm
    garth
    fitfile
    tcxfile
    idbutils
    tornado
  ];

  pythonRelaxDeps = [
    "sqlalchemy"
    "cached-property"
    "tqdm"
    "fitfile"
    "tcxfile"
    "idbutils"
  ];

  # require data files
  disabledTestPaths = [
    "test/test_activities_db.py"
    "test/test_config.py"
    "test/test_copy.py"
    "test/test_db_base.py"
    "test/test_fit_file.py"
    "test/test_garmin_db.py"
    "test/test_garmin_db_objects.py"
    "test/test_garmin_summary_db.py"
    "test/test_monitoring_db.py"
    "test/test_profile_file.py"
    "test/test_summary_db.py"
    "test/test_summary_db_base.py"
    "test/test_tcx_file.py"
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Download and parse data from Garmin Connect or a Garmin watch";
    homepage = "https://github.com/tcgoetz/GarminDB";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "garmindb";
  };
}
