{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "urlscan";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
    rev = version;
    sha256 = "1jxjcq869jimsq1ihk2fbjhp5lj7yga0hbp0msskxyz92afl1kz8";
  };

  propagatedBuildInputs = [ python3Packages.urwid ];

  doCheck = false; # No tests available

  meta = with stdenv.lib; {
    description = "Mutt and terminal url selector (similar to urlview)";
    homepage = https://github.com/firecat53/urlscan;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dpaetzel jfrankenau ];
  };
}
