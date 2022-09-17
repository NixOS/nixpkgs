{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jrnl";
  version = "3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jrnl-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wyN7dlAbQwqvES8qEJ4Zo+fDMM/Lh9tNjf215Ywop10=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ansiwrap
    asteval
    colorama
    cryptography
    keyring
    parsedatetime
    python-dateutil
    pytz
    pyxdg
    pyyaml
    tzlocal
    ruamel-yaml
    rich
  ];

  checkInputs = with python3.pkgs; [
    pytest-bdd
    pytest-xdist
    pytestCheckHook
    toml
  ];

  # Upstream expects a old pytest-bdd version
  # Once it changes we should update here too
  # https://github.com/jrnl-org/jrnl/blob/develop/poetry.lock#L732
  disabledTests = [
    "bdd"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'tzlocal = ">2.0, <3.0"' 'tzlocal = ">2.0, !=3.0"'
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "jrnl"
  ];

  meta = with lib; {
    description = "Simple command line journal application that stores your journal in a plain text file";
    homepage = "https://jrnl.sh/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zalakain ];
  };
}
