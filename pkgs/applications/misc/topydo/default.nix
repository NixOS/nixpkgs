{ lib, python3Packages, fetchFromGitHub, glibcLocales, unittestCheckHook }:

with python3Packages;

buildPythonApplication rec {
  pname = "topydo";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "bram85";
    repo = pname;
    rev = version;
    sha256 = "1lpfdai0pf90ffrzgmmkadbd86rb7250i3mglpkc82aj6prjm6yb";
  };

  propagatedBuildInputs = [
    arrow
    icalendar
    glibcLocales
    prompt-toolkit
    urwid
    watchdog
  ];

  checkInputs = [ unittestCheckHook mock freezegun pylint ];

  # Skip test that has been reported multiple times upstream without result:
  # bram85/topydo#271, bram85/topydo#274.
  preCheck = ''
    substituteInPlace test/test_revert_command.py --replace 'test_revert_ls' 'dont_test_revert_ls'
  '';

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "A cli todo application compatible with the todo.txt format";
    homepage = "https://github.com/bram85/topydo";
    license = licenses.gpl3;
  };
}
