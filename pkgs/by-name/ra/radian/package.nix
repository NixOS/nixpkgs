{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
  R,
  rPackages,
}:

python3Packages.buildPythonApplication rec {
  pname = "radian";
  version = "0.6.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = "radian";
    tag = "v${version}";
    hash = "sha256-gz2VczAgVbvISzvY/v0GvZ/Erv6ipZwPU61r6OJ+3Fo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    R # needed at setup time to detect R_HOME
  ];

  propagatedBuildInputs =
    (with python3Packages; [
      lineedit
      prompt-toolkit
      pygments
      rchitect
    ])
    ++ (with rPackages; [
      reticulate
      askpass
    ]);

  nativeCheckInputs =
    (with python3Packages; [
      pytestCheckHook
      pyte
      pexpect
      ptyprocess
      jedi
    ])
    ++ [ git ];

  makeWrapperArgs = [ "--set R_HOME ${R}/lib/R" ];

  preCheck = ''
    export HOME=$TMPDIR
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
  '';

  pythonImportsCheck = [ "radian" ];

  meta = with lib; {
    description = "21 century R console";
    mainProgram = "radian";
    homepage = "https://github.com/randy3k/radian";
    changelog = "https://github.com/randy3k/radian/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
