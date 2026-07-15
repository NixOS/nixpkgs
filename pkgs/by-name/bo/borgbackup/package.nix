{
  lib,
  stdenv,
  acl,
  e2fsprogs,
  fetchFromGitHub,
  fetchpatch,
  libb2,
  lz4,
  openssh,
  openssl,
  python3,
  xxhash,
  zstd,
  installShellFiles,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

let
  python = python3;
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "borgbackup";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "borgbackup";
    repo = "borg";
    tag = finalAttrs.version;
    hash = "sha256-pMZr9cVr84b948b5Iuevpy6AtMeYo/Ma8uFLuagAYy4=";
  };

  patches = [
    (fetchpatch {
      name = "msgspec-1.2.0-compat.patch";
      url = "https://github.com/borgbackup/borg/commit/364438f58c86aebd157b55bd2202afaf5945e008.patch";
      excludes = [ "docs/changes.rst" ];
      hash = "sha256-YhZDD6i2cn7p00Dgmpqi8uGJzFZzixMZmHPcZroB1sE=";
    })
    (fetchpatch {
      name = "msgspec-1.2.1-compat.patch";
      url = "https://github.com/borgbackup/borg/commit/8abdd3b8bf065dceecd52d2b22d92b3c407a7c1d.patch";
      excludes = [ "docs/changes.rst" ];
      hash = "sha256-bvSRxEzNvejG6PQFkeNDuQB7Zd4/EYPEZkrgjpgQ9Ss=";
    })
    (fetchpatch {
      name = "msgspec-1.2.1-unpacker-compat.patch";
      url = "https://github.com/borgbackup/borg/commit/b09bbed3de095d6ac9d69a42a486ec18523046dc.patch";
      hash = "sha256-F8CIqOcQOLdYn7srsev2op0pgkgt8zdkc5DQUH1c6xg=";
    })
  ];

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
    xxhash
    zstd
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    acl
  ];

  dependencies =
    with python.pkgs;
    [
      msgpack
      packaging
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pyfuse3
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
    pytest9_0CheckHook
    versionCheckHook
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

  passthru.updateScript = nix-update-script {
    # Only match tags formatted as x.y.z (e.g., 1.2.3)
    extraArgs = [
      "--version-regex"
      "^([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  meta = {
    changelog = "https://github.com/borgbackup/borg/blob/${finalAttrs.src.rev}/docs/changes.rst";
    description = "Deduplicating archiver with compression and encryption";
    homepage = "https://www.borgbackup.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix; # Darwin and FreeBSD mentioned on homepage
    mainProgram = "borg";
    maintainers = with lib.maintainers; [
      dotlambda
    ];
  };
})
