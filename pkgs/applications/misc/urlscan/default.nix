{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  name = "urlscan-${version}";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "urlscan";
    rev = version;
    sha256 = "1v26fni64n0lbv37m35plh2bsrvhpb4ibgmg2mv05qfc3df721s5";
  };

  propagatedBuildInputs = [ python3Packages.urwid ];

  meta = with stdenv.lib; {
    description = "Mutt and terminal url selector (similar to urlview)";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dpaetzel jfrankenau ];
  };
}
