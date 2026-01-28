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
  version = "3.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "barman";
    tag = "release/${version}";
    hash = "sha256-n7XKkbhAhgQDFW4qOLVxcqohqmuL9Y83/CkenvyYIvE=";
  };

  patches = [
    ./unwrap-subprocess.patch
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

  disabledTests = [
    # Assertion error
    "test_help_output"
    "test_exits_on_unsupported_target"
    # Requires /dev/sdf to be mounted
    "test_resolve_mounted_volume_failure"
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
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
