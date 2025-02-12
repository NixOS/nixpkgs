{
  lib,

  coreutils,
  fetchFromGitHub,
  python3Packages,
  stdenv,

  # nativeCheckInputs
  debian-devscripts,
  dpkg,
  gitMinimal,
  gitSetupHook,
  man,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-buildpackage";
  version = "0.9.37";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agx";
    repo = "git-buildpackage";
    tag = "debian/${version}";
    hash = "sha256-0gfryd1GrVfL11u/IrtLSJAABRsTpFfPOGxWfVdYtgE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace gbp/command_wrappers.py \
    --replace-fail "/bin/true" "${lib.getExe' coreutils "true"}" \
    --replace-fail "/bin/false" "${lib.getExe' coreutils "false"}"
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    python-dateutil
  ];

  pythonImportsCheck = [
    "gbp"
  ];

  nativeCheckInputs =
    [
      debian-devscripts
      dpkg
      gitMinimal
      gitSetupHook
      man
    ]
    ++ (with python3Packages; [
      coverage
      pytest-cov
      pytestCheckHook
      pyyaml
      rpm
    ]);

  disabledTests =
    [
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

  meta = {
    description = "Suite to help with maintaining Debian packages in Git repositories";
    homepage = "https://honk.sigxcpu.org/piki/projects/git-buildpackage/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "git-buildpackage";
  };
}
