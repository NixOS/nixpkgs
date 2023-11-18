{ lib
, buildPythonApplication
, fetchPypi
# build inputs
, aiofiles
, aiohttp
, attrs
, certifi
, cssselect
, html5lib
, isodate
, json-home-client
, lxml
, pillow
, pygments
, requests
, result
, setuptools
, tenacity
, widlparser
}:

buildPythonApplication rec {
  pname = "bikeshed";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3fVo+B71SsJs+XF4+FWH2nz0ouTnpC/02fXYr1C9Jrk=";
  };

  # Relax requirements from "==" to ">="
  # https://github.com/tabatkins/bikeshed/issues/2178
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "==" ">="
  '';

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    attrs
    certifi
    cssselect
    html5lib
    isodate
    json-home-client
    lxml
    pillow
    pygments
    requests
    result
    setuptools
    tenacity
    widlparser
  ];

  checkPhase = ''
    $out/bin/bikeshed test
  '';

  pythonImportsCheck = [ "bikeshed" ];

  meta = with lib; {
    description = "Preprocessor for anyone writing specifications that converts source files into actual specs";
    longDescription = ''
      Bikeshed is a pre-processor for spec documents, turning a source document
      (containing only the actual spec content, plus several shorthands for linking
      to terms and other things) into a final spec document, with appropriate boilerplate,
      bibliography, indexes, etc all filled in. It's used on specs for CSS
      and many other W3C working groups, WHATWG, the C++ standards committee, and elsewhere!
    '';
    homepage = "https://tabatkins.github.io/bikeshed/";
    license = licenses.cc0;
    maintainers = [];
  };
}
