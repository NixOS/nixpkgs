{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
  R,
  rPackages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "radian";
  version = "0.6.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = "radian";
    tag = "v${version}";
    hash = "sha256-9dpLQ3QRppvwOw4THASfF8kCkIVZmWLALLRwy1LRPiE=";
  };

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
    ++ [
      gitMinimal
      writableTmpDirAsHomeHook
    ];

  makeWrapperArgs = [ "--set R_HOME ${R}/lib/R" ];

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
  '';

  pythonImportsCheck = [ "radian" ];

  meta = {
    description = "21 century R console";
    mainProgram = "radian";
    homepage = "https://github.com/randy3k/radian";
    changelog = "https://github.com/randy3k/radian/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ savyajha ];
  };
}
