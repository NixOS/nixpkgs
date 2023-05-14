{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "tuifimanager";
  version = "2.3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    owner = "GiorgosXou";
    rev = "v.${version}";
    hash = "sha256-KJYPpeBALyg6Gd1GQgJbvGdJbAT47qO9FnSH7GhO4oQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "Send2Trash == 1.8.0" "Send2Trash >= 1.8.0"
  '';

  propagatedBuildInputs = with python3Packages; [ unicurses send2trash ];
  pythonImportsCheck = [ "TUIFIManager" ];

  # Tests currently cause build to fail
  doCheck = false;

  meta = with lib; {
    description = "A cross-platform terminal-based termux-oriented file manager";
    longDescription = ''
      A cross-platform terminal-based termux-oriented file manager (and component),
      meant to be used with a Uni-Curses project or as is. This project is mainly an
      attempt to get more attention to the Uni-Curses project.
    '';
    homepage = "https://github.com/GiorgosXou/TUIFIManager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michaelBelsanti ];
    mainProgram = "tuifi";
  };
}
