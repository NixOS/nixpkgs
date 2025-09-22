{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "chatblade";
  version = "0.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v6X5aqArhp33bm8JELDCUoxE3nsvla4I3n0ZLLMMeJI=";
  };

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "chatblade" ];

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = true;

  dependencies = with python3Packages; [
    openai
    platformdirs
    pylatexenc
    pyyaml
    rich
    tiktoken
  ];

  meta = with lib; {
    homepage = "https://github.com/npiv/chatblade/";
    description = "CLI Swiss Army Knife for ChatGPT";
    mainProgram = "chatblade";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ deejayem ];
  };
}
