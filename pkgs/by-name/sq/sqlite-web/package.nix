{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlite-web";
  version = "0.6.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/Asqu2XEVCS5sFW2GB/W/int1gCZIIgZq8yrevoQ7Yo=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    flask
    peewee
    pygments
  ];

  # no tests in repository
  doCheck = false;

  pythonImportsCheck = [ "sqlite_web" ];

  meta = with lib; {
    description = "Web-based SQLite database browser";
    mainProgram = "sqlite_web";
    homepage = "https://github.com/coleifer/sqlite-web";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
