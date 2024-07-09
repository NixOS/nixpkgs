{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "chatblade";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AjE+1MkSkZOtEUPKEPBKQ3n+aOB8cwsorBpL5skNskU=";
  };

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "chatblade" ];
  propagatedBuildInputs = with python3Packages; [
    aiohttp
    aiosignal
    async-timeout
    attrs
    certifi
    charset-normalizer
    frozenlist
    idna
    markdown-it-py
    mdurl
    multidict
    openai
    platformdirs
    pygments
    pyyaml
    regex
    requests
    rich
    tiktoken
    tqdm
    urllib3
    yarl
  ];

  meta = with lib; {
    homepage = "https://github.com/npiv/chatblade/";
    description = "CLI Swiss Army Knife for ChatGPT";
    mainProgram = "chatblade";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ deejayem ];
  };
}
