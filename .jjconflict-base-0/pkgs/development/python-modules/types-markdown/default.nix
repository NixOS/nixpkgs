{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-markdown";
  version = "3.7.0.20240822";
  pyproject = true;

  src = fetchPypi {
    pname = "types-Markdown";
    inherit version;
    hash = "sha256-GDVXyfT4Zb3v2PX5ajgUXDGBknHN4RHTVVfDvSBp540=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "markdown-stubs" ];

  meta = with lib; {
    description = "Typing stubs for Markdown";
    homepage = "https://pypi.org/project/types-Markdown/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
