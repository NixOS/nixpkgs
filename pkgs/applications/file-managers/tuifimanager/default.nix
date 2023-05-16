<<<<<<< HEAD
{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tuifi-manager";
  version = "3.3.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "GiorgosXou";
    repo = "TUIFIManager";
    rev = "v.${version}";
    hash = "sha256-yBMme0LJSlEXPxE9NMr0Z5VJWcWOzzdvbTnavkLHsvo=";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "Send2Trash == 1.8.0" "Send2Trash >= 1.8.0"
  '';

<<<<<<< HEAD
  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    send2trash
    unicurses
  ];
  pythonImportsCheck = [ "TUIFIManager" ];

=======
  propagatedBuildInputs = with python3Packages; [ unicurses send2trash ];
  pythonImportsCheck = [ "TUIFIManager" ];

  # Tests currently cause build to fail
  doCheck = false;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A cross-platform terminal-based termux-oriented file manager";
    longDescription = ''
      A cross-platform terminal-based termux-oriented file manager (and component),
      meant to be used with a Uni-Curses project or as is. This project is mainly an
      attempt to get more attention to the Uni-Curses project.
    '';
    homepage = "https://github.com/GiorgosXou/TUIFIManager";
<<<<<<< HEAD
    changelog = "https://github.com/GiorgosXou/TUIFIManager/blob/${src.rev}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michaelBelsanti ];
    mainProgram = "tuifi";
  };
}
