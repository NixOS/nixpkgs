{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hpp2plantuml";
  version = "0.8.6";
  format = "wheel";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    format = "wheel";
    hash = "sha256-9FggDDOxWr4z1DBbvYLyvgs3CCguFjq3I4E9ULwL0+Q=";
  };

  propagatedBuildInputs = with python3Packages; [
    jinja2
    cppheaderparser
  ];

  pythonImportsCheck = [ "hpp2plantuml" ];

  nativeCheckInputs = with python3Packages; [ pytest ];

  meta = {
    description = "Convert C++ header files to PlantUML";
    homepage = "https://github.com/thibaultmarin/hpp2plantuml";
    license = lib.licenses.mit;
    mainProgram = "hpp2plantuml";
    maintainers = with lib.maintainers; [ eymeric ];
  };
})
