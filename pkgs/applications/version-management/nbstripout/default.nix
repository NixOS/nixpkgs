{ lib
, python3
, fetchFromGitHub
, git
}:

python3.pkgs.buildPythonApplication rec {
  version = "0.7.1";
  pname = "nbstripout";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kynan";
    repo = "nbstripout";
    rev = "refs/tags/${version}";
    hash = "sha256-LqUK8JDUV0Fbr24BSzPz1Idbdu0Z1FXyvv3J4z1yclE=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies = [
    python3.pkgs.nbformat
  ];

  nativeCheckInputs = [
    git
    python3.pkgs.pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
    substituteInPlace pytest.ini \
      --replace-fail "--ruff" ""
  '';

  meta = {
    description = "Strip output from Jupyter and IPython notebooks";
    homepage = "https://github.com/kynan/nbstripout";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
    mainProgram = "nbstripout";
  };
}
