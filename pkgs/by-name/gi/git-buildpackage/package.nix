{
  lib,
  stdenv,

  coreutils,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,

  # nativeCheckInputs
  cpio,
  debian-devscripts,
  dpkg,
  gitMinimal,
  gitSetupHook,
  libzip,
  man,
  rpm,
  unzip,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-buildpackage";
  version = "0.9.43";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agx";
    repo = "git-buildpackage";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-UezdxQZu0gcZB479qtmW0F5IFDsi7WRhjl2UI1yhlY0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace gbp/command_wrappers.py gbp/deb/changelog.py \
      --replace-fail "/bin/true" "${lib.getExe' coreutils "true"}"

    substituteInPlace gbp/deb/__init__.py \
      --replace-fail "/usr/bin/dpkg" "${lib.getExe dpkg}"

    substituteInPlace tests/test_12_deb.py \
      --replace-fail "/tmp" "/build"
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    python-dateutil
    pyyaml
    rpm
    notify2
    requests
  ];

  pythonImportsCheck = [
    "gbp"
  ];

  env = {
    # don't add pytest and pytest-cov to setup_requires
    WITHOUT_PYTESTS = true;
    # fix run of dch in tests
    DEBEMAIL = "test@example.com";
  };

  nativeCheckInputs = [
    cpio
    debian-devscripts
    dpkg
    gitMinimal
    gitSetupHook
    libzip # for zipmerge executable
    man
    rpm
    unzip
  ]
  ++ (with python3Packages; [
    pytest-cov-stub
    pytestCheckHook
  ]);

  disabledTests = [
    # gbp.command_wrappers.CommandExecFailed:
    # Couldn't commit to 'pristine-tar' with upstream 'upstream':
    # execution failed: [Errno 2] No such file or directory: 'pristine-tar'
    "tests.doctests.test_PristineTar.test_pristine_tar"

    # When gitMinimal is used instead of git:
    # UNEXPECTED EXCEPTION: GitRepositoryError("Invalid git command 'branch': No manual entry for git-branch")
    "tests.doctests.test_GitRepository.test_repo"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # gbp.git.repository.GitRepositoryError:
    # Cannot create Git repository at '/does/not/exist':
    # [Errno 30] Read-only file system: '/does'
    "tests.doctests.test_GitRepository.test_create_noperm"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "debian/(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/agx/git-buildpackage/blob/${finalAttrs.src.tag}/debian/changelog";
    description = "Suite to help with maintaining Debian packages in Git repositories";
    homepage = "https://honk.sigxcpu.org/piki/projects/git-buildpackage/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "git-buildpackage";
  };
})
