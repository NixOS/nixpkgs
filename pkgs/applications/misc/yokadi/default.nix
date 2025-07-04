{
  lib,
  fetchurl,
  buildPythonApplication,
  python-dateutil,
  sqlalchemy,
  setproctitle,
  icalendar,
  colorama,
}:

buildPythonApplication rec {
  pname = "yokadi";
  version = "1.3.0";
  format = "setuptools";

  src = fetchurl {
    url = "https://yokadi.github.io/download/${pname}-${version}.tar.gz";
    hash = "sha256-zF2ffHeU+i7wzu1u4DhQ5zJXr8AjXboiyFAisXNX6TM=";
  };

  dependencies = [
    python-dateutil
    sqlalchemy
    setproctitle
    icalendar
    colorama
  ];

  # Yokadi doesn't have any tests
  doCheck = false;

  meta = {
    description = "Command line oriented, sqlite powered, todo-list";
    homepage = "https://yokadi.github.io/index.html";
    mainProgram = "yokadi";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.nkpvk ];
  };
}
