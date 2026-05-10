{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pipreqs";
  version = "0.4.13";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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

  meta = {
    description = "Generate requirements.txt file for any project based on imports";
    homepage = "https://github.com/bndr/pipreqs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ psyanticy ];
    mainProgram = "pipreqs";
  };
})
