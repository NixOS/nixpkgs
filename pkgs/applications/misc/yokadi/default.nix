{ stdenv, fetchurl, buildPythonApplication, dateutil,
  sqlalchemy, setproctitle, icalendar, pycrypto }:

buildPythonApplication rec {
  pname = "yokadi";
  version = "1.1.1";

  src = fetchurl {
    url = "https://yokadi.github.io/download/${pname}-${version}.tar.bz2";
    sha256 = "af201da66fd3a8435b2ccd932082ab9ff13f5f2e3d6cd3624f1ab81c577aaf17";
  };

  propagatedBuildInputs = [
    dateutil
    sqlalchemy
    setproctitle
    icalendar
    pycrypto
  ];

  # Yokadi doesn't have any tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A command line oriented, sqlite powered, todo-list";
    homepage = https://yokadi.github.io/index.html;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.nipav ];
  };
}
