{ stdenv, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "topydo";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "bram85";
    repo = pname;
    rev = version;
    sha256 = "0b3dz137lpbvpjvfy42ibqvj3yk526x4bpn819fd11lagn77w69r";
  };

  propagatedBuildInputs = [
    arrow
    icalendar
    glibcLocales
    prompt_toolkit
    urwid
    watchdog
  ];

  checkInputs = [ mock freezegun pylint ];

  # Skip test that has been reported multiple times upstream without result:
  # bram85/topydo#271, bram85/topydo#274.
  checkPhase = ''
    substituteInPlace test/test_revert_command.py --replace 'test_revert_ls' 'dont_test_revert_ls'
    python -m unittest discover
  '';

  LC_ALL="en_US.UTF-8";

  meta = with stdenv.lib; {
    description = "A cli todo application compatible with the todo.txt format";
    homepage = "https://github.com/bram85/topydo";
    license = licenses.gpl3;
  };
}
