{ stdenv, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "topydo";
  version = "0.13";
  name  = "${pname}-${version}";

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

  checkInputs = [ mock freezegun coverage green pylint ];

  LC_ALL="en_US.UTF-8";

  meta = with stdenv.lib; {
    description = "A cli todo application compatible with the todo.txt format";
    homepage = https://github.com/bram85/topydo;
    license = licenses.gpl3;
  };
}
