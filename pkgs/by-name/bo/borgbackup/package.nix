{
  lib,
  stdenv,
  acl,
  e2fsprogs,
  fetchFromGitHub,
  libb2,
  lz4,
  openssh,
  openssl,
  python3,
  xxHash,
  zstd,
  installShellFiles,
  nixosTests,
  nix-update-script,
}:

let
  python = python3;
in
python.pkgs.buildPythonApplication rec {
  pname = "borgbackup";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "borgbackup";
    repo = "borg";
    tag = version;
    hash = "sha256-KoOulgOkMgnkN3I0Gw9z0YKZvqvPJ0A9sIAxRLOlchU=";
  };

  postPatch = ''
    # sandbox does not support setuid/setgid/sticky bits
    substituteInPlace src/borg/testsuite/archiver.py \
      --replace-fail "0o4755" "0o0755"
  '';

  build-system = with python.pkgs; [
    cython
    setuptools-scm
    pkgconfig
  ];

  nativeBuildInputs = with python.pkgs; [
    # docs
    sphinxHook
    sphinxcontrib-jquery
    guzzle-sphinx-theme

    # shell completions
    installShellFiles
  ];

  sphinxBuilders = [
    "singlehtml"
    "man"
  ];

  buildInputs = [
    libb2
    lz4
    xxHash
    zstd
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    acl
  ];

  dependencies = with python.pkgs; [
    msgpack
    packaging
    (if stdenv.hostPlatform.isLinux then pyfuse3 else llfuse)
  ];

  makeWrapperArgs = [
    ''--prefix PATH ':' "${openssh}/bin"''
  ];

  preInstallSphinx = ''
    # remove invalid outputs for manpages
    rm .sphinx/man/man/_static/jquery.js
    rm .sphinx/man/man/_static/_sphinx_javascript_frameworks_compat.js
    rmdir .sphinx/man/man/_static/
  '';

  postInstall = ''
    installShellCompletion --cmd borg \
      --bash scripts/shell_completions/bash/borg \
      --fish scripts/shell_completions/fish/borg.fish \
      --zsh scripts/shell_completions/zsh/_borg
  '';

  nativeCheckInputs = with python.pkgs; [
    e2fsprogs
    py
    pytest-benchmark
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlags = [
    "--benchmark-skip"
    "--pyargs"
    "borg.testsuite"
  ];

  disabledTests = [
    # fuse: device not found, try 'modprobe fuse' first
    "test_fuse"
    "test_fuse_allow_damaged_files"
    "test_fuse_mount_hardlinks"
    "test_fuse_mount_options"
    "test_fuse_versions_view"
    "test_migrate_lock_alive"
    "test_readonly_mount"
    # Error: Permission denied while trying to write to /var/{,tmp}
    "test_get_cache_dir"
    "test_get_keys_dir"
    "test_get_security_dir"
    "test_get_config_dir"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Tests create files with append-only flags that cause cleanup issues on macOS
    "test_extract_restores_append_flag"
    "test_file_status_excluded"
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  passthru.tests = {
    inherit (nixosTests) borgbackup;
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  disabled = python.pythonOlder "3.9";

  passthru.updateScript = nix-update-script {
    # Only match tags formatted as x.y.z (e.g., 1.2.3)
    extraArgs = [
      "--version-regex"
      "^([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  meta = with lib; {
    changelog = "https://github.com/borgbackup/borg/blob/${src.rev}/docs/changes.rst";
    description = "Deduplicating archiver with compression and encryption";
    homepage = "https://www.borgbackup.org";
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    mainProgram = "borg";
    maintainers = with maintainers; [
      dotlambda
      globin
    ];
  };
}
