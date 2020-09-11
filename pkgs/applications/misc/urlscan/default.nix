{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "urlscan";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
    rev = version;
    sha256 = "16g7dzvjcfhaz52wbmcapamy55l7vfhgizqy3m8dv9gkmy8vap89";
  };

  propagatedBuildInputs = [ python3Packages.urwid ];

  doCheck = false; # No tests available

  meta = with stdenv.lib; {
    description = "Mutt and terminal url selector (similar to urlview)";
    homepage = "https://github.com/firecat53/urlscan";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dpaetzel jfrankenau ];
  };
}
