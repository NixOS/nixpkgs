{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mloader";
  version = "1.1.12";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-0o4FvhuFudNSEL6fwBVqxldaNePbbidY9utDqXiLRNc=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = [ "protobuf" ];

  dependencies = with python3Packages; [
    click
    protobuf
    requests
  ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [ "mloader" ];

  meta = {
    description = "Command-line tool to download manga from mangaplus";
    homepage = "https://github.com/hurlenko/mloader";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "mloader";
  };
})
