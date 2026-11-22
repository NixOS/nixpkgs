{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "chatblade";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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

  meta = {
    homepage = "https://github.com/npiv/chatblade/";
    description = "CLI Swiss Army Knife for ChatGPT";
    mainProgram = "chatblade";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ deejayem ];
  };
})
