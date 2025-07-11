{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ffq";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ffq";
    hash = "sha256-JHsdolCQUZcI44EfhJphLFbNtB7aeEUABJCZLQodmLY=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    frozendict
    lxml
    requests
  ];

  pythonImportsCheck = [
    "ffq"
  ];

  meta = {
    description = "CLI tool to find sequencing data";
    longDescription = "A command line tool that makes it easier to find sequencing data from SRA / GEO / ENCODE / ENA / EBI-EMBL / DDBJ / Biosample";
    homepage = "https://github.com/pachterlab/ffq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "ffq";
  };
}
