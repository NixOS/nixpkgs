{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
  R,
  rPackages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "radian";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = "radian";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UgAMyn0mqMPH2qr2JXyJXLtp8i4PNnSIhwmToWtPF/k=";
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

  checkInputs = [ rPackages.renv ];

  makeWrapperArgs = [
    "--set"
    "R_HOME"
    "${R}/lib/R"
    "--prefix"
    "PYTHONPATH"
    ":"
    "${placeholder "out"}/${python3Packages.python.sitePackages}:${python3Packages.makePythonPath finalAttrs.propagatedBuildInputs}"
  ];

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
  '';

  pythonImportsCheck = [ "radian" ];

  meta = {
    description = "21 century R console";
    mainProgram = "radian";
    homepage = "https://github.com/randy3k/radian";
    changelog = "https://github.com/randy3k/radian/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ savyajha ];
  };
})
