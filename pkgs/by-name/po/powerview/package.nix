{
  fetchFromGitHub,
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "powerview";
  version = "2025.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "aniqfakhrul";
    repo = "powerview.py";
    rev = "main";
    hash = "sha256-8ZTbPtmdyvDTJ1Um0tFUJ8rMsOp+lQhgnAj42LJbUwk=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    impacket
    ldap3-bleeding-edge
    dnspython
    future
    gnureadline
    validators
    dsinternals
    chardet
    tabulate
    requests-ntlm
    python-dateutil
    flask
  ];

  # Exclude argparse from runtime dependency checks since it is part of Python's standard library
  pythonRemoveDeps = [ "argparse" ];

  doCheck = false;

  meta = {
    description = "PowerView.py is an alternative for the awesome original PowerView.ps1 script.";
    longDescription = ''
      PowerView.py is an alternative for the awesome original PowerView.ps1 script.
      Most of the modules used in PowerView are available here (some of the flags are changed).
      The main goal is to achieve an interactive session without having to repeatedly authenticate to LDAP.
    '';
    homepage = "https://github.com/aniqfakhrul/powerview.py";
    license = lib.licenses.gpl3Only;
    mainProgram = "powerview";
  };
}
