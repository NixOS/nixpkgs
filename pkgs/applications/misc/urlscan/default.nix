{ lib
<<<<<<< HEAD
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "urlscan";
  version = "1.0.1";
  format = "pyproject";
=======
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "urlscan";
  version = "0.9.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-OzcoOIgEiadWrsUPIxBJTuZQYjScJBYKyqCu1or6fz8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = with python3.pkgs; [
    urwid
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "urlscan"
  ];
=======
    rev = version;
    hash = "sha256-lCOOVAdsr5LajBGY7XUi4J5pJqm5rOH5IMKhA6fju5w=";
  };

  propagatedBuildInputs = [
    python3Packages.urwid
  ];

  doCheck = false; # No tests available

  pythonImportsCheck = [ "urlscan" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Mutt and terminal url selector (similar to urlview)";
    homepage = "https://github.com/firecat53/urlscan";
<<<<<<< HEAD
    changelog = "https://github.com/firecat53/urlscan/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dpaetzel jfrankenau ];
  };
}
