{
  lib,
  fetchFromGitHub,
  file,
  python3Packages,
  rsync,
  versionCheckHook,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "barman";
  version = "3.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "barman";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-PWPcEymAHxKdmTWcN0X5umE4fVYWBx29nTspElcqWW8=";
  };

  patches = [
    ./01-unwrap-subprocess.patch
    # 20260917: known issue in upstream (https://github.com/EnterpriseDB/barman/issues/753) since 2023. Temporary patch until redesign implemented or this patch is upstreamed (https://github.com/EnterpriseDB/barman/pull/1223)
    ./02-py-stdlib-stat.patch
  ];

  # https://github.com/EnterpriseDB/barman/blob/release/3.14.1/barman/encryption.py#L214
  postPatch = ''
    substituteInPlace src/barman/encryption.py \
      --replace-fail '"file"' '"${lib.getExe file}"'
  '';

  build-system = with python3Packages; [
    distutils
    setuptools
    uv-build
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  nativeCheckInputs = [
    python3Packages.lz4
    python3Packages.mock
    python3Packages.pytestCheckHook
    python3Packages.zstandard
    rsync
  ];

  disabledTests = [
    # 20260917: AssertionError: assert 'usage: __mai...ilog string\n' == 'usage: pytho...ilog string\n'
    # https://github.com/EnterpriseDB/barman/blob/release/3.20.0/tests/test_cli.py#L2893
    "test_help_output"
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
    changelog = "https://github.com/EnterpriseDB/barman/blob/${finalAttrs.src.tag}/RELNOTES.md";
    mainProgram = "barman";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
