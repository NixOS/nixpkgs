{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "chatblade";
  version = "0.6.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4zLyIrBkilZ2ciBRkU41iK6Q8xDTdFJYOYalNeEMApg=";
  };

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "chatblade" ];
  propagatedBuildInputs = with python3Packages; [
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
