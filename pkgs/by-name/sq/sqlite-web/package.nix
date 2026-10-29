{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sqlite-web";
  version = "0.6.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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

  meta = {
    description = "Web-based SQLite database browser";
    mainProgram = "sqlite_web";
    homepage = "https://github.com/coleifer/sqlite-web";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.costrouc ];
  };
})
