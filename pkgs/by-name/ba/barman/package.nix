{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  file,
  python3Packages,
  rsync,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "barman";
  version = "3.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "barman";
    tag = "release/${version}";
    hash = "sha256-Z3+PgUJcyG/M05hMmIhRr3HttzHUDx7BGIs44LA/qE4=";
  };

  patches = [
    ./unwrap-subprocess.patch
    # fix building with Python 3.13
    (fetchpatch2 {
      url = "https://github.com/EnterpriseDB/barman/commit/931f997f1d73bbe360abbca737bea9ae93172989.patch?full_index=1";
      hash = "sha256-0aqyjsEabxLf4dpC4DeepmypAl7QfCedh7vy98iVifU=";
    })
  ];

  # https://github.com/EnterpriseDB/barman/blob/release/3.14.1/barman/encryption.py#L214
  postPatch = ''
    substituteInPlace barman/encryption.py \
      --replace-fail '"file"' '"${lib.getExe file}"'
  '';

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

  nativeCheckInputs = [
    python3Packages.lz4
    python3Packages.mock
    python3Packages.pytestCheckHook
    python3Packages.zstandard
    rsync
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

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^release/(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "Backup and Recovery Manager for PostgreSQL";
    homepage = "https://www.pgbarman.org/";
    changelog = "https://github.com/EnterpriseDB/barman/blob/${src.tag}/RELNOTES.md";
    mainProgram = "barman";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ freezeboy ];
    platforms = lib.platforms.unix;
  };
}
