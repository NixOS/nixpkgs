{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  python3Packages,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "barman";
  version = "3.13.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "barman";
    tag = "release/${version}";
    hash = "sha256-ffedLH7b/Z1y+yL5EkFJIGdksQZEKc3uu3KOyNc2plw=";
  };

  patches = [
    ./unwrap-subprocess.patch
    # fix building with Python 3.13
    (fetchpatch2 {
      url = "https://github.com/EnterpriseDB/barman/commit/931f997f1d73bbe360abbca737bea9ae93172989.patch?full_index=1";
      hash = "sha256-0aqyjsEabxLf4dpC4DeepmypAl7QfCedh7vy98iVifU=";
    })
  ];

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
    zstandard
    lz4
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
