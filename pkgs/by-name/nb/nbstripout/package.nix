{
  lib,
  python3,
  fetchPypi,
  fetchFromGitHub,
  coreutils,
  gitMinimal,
  mercurial,
}:

python3.pkgs.buildPythonApplication rec {
  version = "0.8.1";
  format = "setuptools";
  pname = "nbstripout";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6qyLa05yno3+Hl3ywPi6RKvFoXplRI8EgBQfgL4jC7E=";
  };

  testAssets = fetchFromGitHub {
    owner = "kynan";
    repo = "nbstripout";
    rev = "${version}";
    hash = "sha256-OSJLrWkYQIhcdyofS3Bo39ppsU6K3A4546UKB8Q1GGg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    nbformat
  ];

  nativeCheckInputs =
    [
      coreutils
      gitMinimal
      mercurial
    ]
    ++ (with python3.pkgs; [
      pytestCheckHook
    ]);

  checkInputs = [
    testAssets
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$out/bin:$PATH
    git config --global init.defaultBranch main

    cp -r --no-preserve=mode,ownership ${testAssets}/tests/e2e_notebooks $TMPDIR/e2e_notebooks
    chmod -R +w $TMPDIR/e2e_notebooks
    substituteInPlace tests/test_end_to_end.py --replace "tests/e2e_notebooks" "$TMPDIR/e2e_notebooks"
  '';

  meta = {
    description = "Strip output from Jupyter and IPython notebooks";
    homepage = "https://github.com/kynan/nbstripout";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
    mainProgram = "nbstripout";
  };
}
