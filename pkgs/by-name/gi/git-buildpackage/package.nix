{
  coreutils,
  debian-devscripts,
  dpkg,
  fetchFromGitHub,
  git,
  lib,
  man,
  python3,
  stdenv,
}:

python3.pkgs.buildPythonApplication rec {
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
    python3.pkgs.setuptools
  ];

  dependencies = with python3.pkgs; [
    python-dateutil
  ];

  pythonImportsCheck = [
    "gbp"
  ];

  nativeCheckInputs = with python3.pkgs; [
    coverage
    debian-devscripts
    dpkg
    git
    pytest-cov
    pytestCheckHook
    man
    pyyaml
    rpm
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
  '';

  disabledTests =
    [
      # gbp.command_wrappers.CommandExecFailed:
      # Couldn't commit to 'pristine-tar' with upstream 'upstream':
      # execution failed: [Errno 2] No such file or directory: 'pristine-tar'
      "tests.doctests.test_PristineTar.test_pristine_tar"
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
