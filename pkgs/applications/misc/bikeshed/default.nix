{ lib
, buildPythonApplication
, fetchPypi
# build inputs
, about-time
, aiofiles
, aiohttp
, aiosignal
, alive-progress
, async-timeout
, attrs
, certifi
, charset-normalizer
, cssselect
, frozenlist
, html5lib
, idna
, isodate
, json-home-client
, kdl-py
, lxml
, multidict
, pillow
, pygments
, requests
, result
, setuptools
, six
, tenacity
, typing-extensions
, uri-template
, urllib3
, webencodings
, widlparser
, yarl
}:

buildPythonApplication rec {
  pname = "bikeshed";
  version = "5.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oba7Ba61uwQQByLKIy6oRywNP5jGkbYwuBMwln+dcaw=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = true;

  dependencies = [
    about-time
    aiofiles
    aiohttp
    aiosignal
    alive-progress
    async-timeout
    attrs
    certifi
    charset-normalizer
    cssselect
    frozenlist
    html5lib
    idna
    isodate
    json-home-client
    kdl-py
    lxml
    multidict
    pillow
    pygments
    requests
    result
    setuptools
    six
    tenacity
    typing-extensions
    uri-template
    urllib3
    webencodings
    widlparser
    yarl
  ];

  checkPhase = ''
    $out/bin/bikeshed test
  '';

  pythonImportsCheck = [ "bikeshed" ];

  meta = with lib; {
    description = "Preprocessor for anyone writing specifications that converts source files into actual specs";
    mainProgram = "bikeshed";
    longDescription = ''
      Bikeshed is a pre-processor for spec documents, turning a source document
      (containing only the actual spec content, plus several shorthands for linking
      to terms and other things) into a final spec document, with appropriate boilerplate,
      bibliography, indexes, etc all filled in. It's used on specs for CSS
      and many other W3C working groups, WHATWG, the C++ standards committee, and elsewhere!
    '';
    homepage = "https://tabatkins.github.io/bikeshed/";
    license = licenses.cc0;
    maintainers = [ ];
  };
}
