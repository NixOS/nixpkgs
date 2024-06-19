{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "epy";
  version = "2023.6.11";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "epy_reader";
    hash = "sha256-gel503e8DXjrMJK9lpAZ6GxQsrahKX+SjiyRwKbiJUY=";
  };

  nativeBuildInputs = [ python3Packages.poetry-core ];

  pythonImportsCheck = [
    "epy_reader.cli"
    "epy_reader.reader"
  ];

  meta = {
    description = "CLI Ebook Reader";
    homepage = "https://github.com/wustho/epy";
    mainProgram = "epy";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ perstark ];
  };
}
