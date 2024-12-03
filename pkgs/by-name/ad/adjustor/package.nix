{
  fetchFromGitHub,
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "adjustor";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "adjustor";
    rev = "refs/tags/v${version}";
    hash = "sha256-daHNh/pVi5ru1trveMSqX28C7VSlbKSZMf+x2+ldC2Y=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    rich
    pyroute2
    fuse
    pygobject3
    dbus-python
  ];

  # This package doesn't have upstream tests.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/adjustor/";
    description = "Adjustor TDP plugin for Handheld Daemon";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ toast ];
    mainProgram = "hhd";
  };
}
