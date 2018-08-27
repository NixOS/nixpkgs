{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "urlscan";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
    rev = version;
    sha256 = "0vad1g234r9agvkdsry9xb6hmn6lg4mygfcy0mg68gibmrg7h1ji";
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
