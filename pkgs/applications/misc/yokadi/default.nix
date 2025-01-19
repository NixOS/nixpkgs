{
  lib,
  fetchurl,
  buildPythonApplication,
  python-dateutil,
  sqlalchemy,
  setproctitle,
  icalendar,
}:

buildPythonApplication rec {
  pname = "yokadi";
  version = "1.2.0";

  src = fetchurl {
    url = "https://yokadi.github.io/download/${pname}-${version}.tar.gz";
    sha256 = "681c8aa52b2e4b5255e1311e76b4b81dcb63ee7f6ca3a47178e684c06baf330f";
  };

  propagatedBuildInputs = [
    python-dateutil
    sqlalchemy
    setproctitle
    icalendar
  ];

  # Yokadi doesn't have any tests
  doCheck = false;

  meta = {
    description = "Command line oriented, sqlite powered, todo-list";
    homepage = "https://yokadi.github.io/index.html";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.nkpvk ];
  };
}
