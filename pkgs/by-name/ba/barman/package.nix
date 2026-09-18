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
    longDescription = ''
      **Barman** (Backup and Recovery Manager) is an open-source administration
      tool for disaster recovery of PostgreSQL servers written in Python.

      It allows your organisation to perform remote backups of multiple servers
      in business critical environments and help DBAs during the recovery phase.

      Barman’s most wanted features include backup catalogs, incremental backup,
      retention policies, remote recovery, archiving and compression of WAL files
      and backups.

      Barman was originally developed by 2ndQuadrant, and is now maintained by
      [EnterpriseDB](https://enterprisedb.com).

      The main features and goals of Barman are:

      * Full hot physical backup of a PostgreSQL server
      * Point-In-Time-Recovery (PITR)
      * Management of multiple PostgreSQL servers
      * Remote backup via rsync/SSH or `pg_basebackup` (including a 9.2+ standby)
      * Support for both local and remote (via SSH) recovery
      * Support for both WAL archiving and streaming
      * Support for synchronous WAL streaming (“zero data loss”, RPO=0)
      * Incremental backup and recovery
      * Incremental backup and recovery
      * Parallel backup and recovery
      * Hub of WAL files for enhanced integration with standby servers
      * Management of retention policies for backups and WAL files
      * Server status and information
      * Compression of WAL files (bzip2, gzip or custom)
      * Management of base backups and WAL files through a catalogue
      * A simple INI configuration file
      * Totally written in Python
      * Relocation of PGDATA and tablespaces at recovery time
      * General and disk usage information of backups
      * Server diagnostics for backup
      * Integration with standard archiving tools (e.g. tar)
      * Pre/Post backup hook scripts
      * Local storage of metadata
    '';
    homepage = "https://pgbarman.org";
    changelog = "https://github.com/EnterpriseDB/barman/blob/${finalAttrs.src.tag}/RELNOTES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      debtquity
    ];
    mainProgram = "barman";
    platforms = lib.platforms.unix;
  };
})
