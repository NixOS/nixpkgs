{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pipreqs";
  version = "0.4.13";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oX8WeIC2khvjdTPOTIHdxuIrRlwQeq1VfbQ7Gt1WqZs=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    yarg
    docopt
  ];

  # Tests requires network access. Works fine without sandboxing
  doCheck = false;

  pythonImportsCheck = [ "pipreqs" ];

  meta = with lib; {
    description = "Generate requirements.txt file for any project based on imports";
    homepage = "https://github.com/bndr/pipreqs";
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
    mainProgram = "pipreqs";
  };
}
