{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "garmindb";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tcgoetz";
    repo = "garmindb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uM1bklCP/BWsc51LawDQPHzEgPHr8U4uVSoeF/C8oFY=";
  };

  pythonRelaxDeps = [
    "sqlalchemy"
    "cached-property"
    "garth"
    "tqdm"
    "fitfile"
    "tcxfile"
    "idbutils"
  ];

  build-system = with python3Packages; [ setuptools ];

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

  pythonImportsCheck = [ "garmindb" ];

  meta = {
    description = "Download and parse data from Garmin Connect or a Garmin watch";
    homepage = "https://github.com/tcgoetz/GarminDB";
    changelog = "https://github.com/tcgoetz/GarminDB/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      ethancedwards8
      matthiasbeyer
    ];
    mainProgram = "garmindb";
  };
})
