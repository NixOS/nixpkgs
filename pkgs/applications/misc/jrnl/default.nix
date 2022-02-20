{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jrnl";
  version = "2.8.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jrnl-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Edu+GW/D+R5r0R750Z1f8YUVPMYbm9PK4D73sTDzDEc=";
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
  ];

  checkInputs = with python3.pkgs; [
    pytest-bdd
    pytestCheckHook
    toml
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
