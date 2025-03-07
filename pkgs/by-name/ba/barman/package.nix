{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "barman";
  version = "3.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "barman";
    tag = "release/${version}";
    hash = "sha256-X39XOv8HJdSjMjMMnmB7Gxjseg5k/LuKICTxapcHVsU=";
  };

  patches = [ ./unwrap-subprocess.patch ];

  build-system = with python3Packages; [
    distutils
    setuptools
  ];

  dependencies = with python3Packages; [
    argcomplete
    azure-identity
    azure-mgmt-compute
    azure-storage-blob
    boto3
    distutils
    google-cloud-compute
    google-cloud-storage
    grpcio
    psycopg2
    python-dateutil
    python-snappy
  ];

  nativeCheckInputs = with python3Packages; [
    mock
    pytestCheckHook
    versionCheckHook
  ];

  disabledTests =
    [
      # Assertion error
      "test_help_output"
      "test_exits_on_unsupported_target"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # FsOperationFailed
      "test_get_file_mode"
    ];

  meta = with lib; {
    description = "Backup and Recovery Manager for PostgreSQL";
    homepage = "https://www.pgbarman.org/";
    changelog = "https://github.com/EnterpriseDB/barman/blob/release/${version}/NEWS";
    mainProgram = "barman";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.unix;
  };
}
