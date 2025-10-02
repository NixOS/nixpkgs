{
  lib,
  fetchFromGitHub,
  python3,
  libarchive,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "stacs";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stacscan";
    repo = "stacs";
    tag = version;
    hash = "sha256-u0yFzId5RAOnJfTDPRUc8E624zIWyCDe3/WlrJ5iuxA=";
  };

  # remove upstream workaround for darwin
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'if platform.system() == "Darwin":' "if False:"
  '';

  buildInputs = [ libarchive ];

  build-system = with python3.pkgs; [
    pybind11
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    click
    colorama
    pydantic_1
    yara-python
    zstandard
  ];

  pythonRelaxDeps = [ "yara-python" ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "stacs"
  ];

  meta = {
    description = "Static token and credential scanner";
    mainProgram = "stacs";
    homepage = "https://github.com/stacscan/stacs";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
