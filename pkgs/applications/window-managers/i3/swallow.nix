{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  poetry-core,
  i3ipc,
  xlib,
  six,
}:

buildPythonApplication rec {
  pname = "i3-swallow";
  version = "unstable-2022-02-19";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jamesofarrell";
    repo = "i3-swallow";
    rev = "6fbc04645c483fe733de56b56743e453693d4c78";
    sha256 = "1l3x8mixwq4n0lnyp0wz5vijgnypamq6lqjazcd2ywl2jv8d6fif";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    i3ipc
    xlib
    six
  ];

  # No tests available
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jamesofarrell/i3-swallow";
    description = "Swallow a terminal window in i3wm";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "swallow";
    maintainers = [ ];
  };
}
