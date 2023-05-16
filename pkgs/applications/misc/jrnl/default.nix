{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jrnl";
<<<<<<< HEAD
  version = "4.0.1";
=======
  version = "3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jrnl-org";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-NpI19NQxfDiqcfFI9kMqfMboI4fQTqCG7AoG9o8YoEI=";
=======
    sha256 = "sha256-e2w0E8t6s0OWx2ROme2GdyzWhmCc6hnMfSdLTZqt3bg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeCheckInputs = with python3.pkgs; [
    pytest-bdd
    pytest-xdist
    pytestCheckHook
    toml
  ];

<<<<<<< HEAD
=======
  # Upstream expects a old pytest-bdd version
  # Once it changes we should update here too
  # https://github.com/jrnl-org/jrnl/blob/develop/poetry.lock#L732
  disabledTests = [
    "bdd"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'rich = "^12.2.0"' 'rich = ">=12.2.0, <14.0.0"'
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "jrnl"
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/jrnl-org/jrnl/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Simple command line journal application that stores your journal in a plain text file";
    homepage = "https://jrnl.sh/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bryanasdev000 zalakain ];
<<<<<<< HEAD
    mainProgram = "jrnl";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
