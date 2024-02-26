{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "epy";
  version = "2023.6.11";

  src = fetchPypi {
    inherit version;
    pname = "epy_reader";
    hash = "sha256-gel503e8DXjrMJK9lpAZ6GxQsrahKX+SjiyRwKbiJUY=";
  };

  # Project has no tests
  doCheck = false;

  meta = {
    description = "CLI Ebook Reader";
    homepage = "https://github.com/wustho/epy";
    mainProgram = "epy";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ perstark ];
  };
}
