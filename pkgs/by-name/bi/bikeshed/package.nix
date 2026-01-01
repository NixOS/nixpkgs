{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "bikeshed";
<<<<<<< HEAD
  version = "7.0.6";
=======
  version = "5.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-0lO5TlAnUMtJp81XQEXpxt3yBz3zx6ff+vO/LYJfFZA=";
  };

  patches = [ ./remove-install-check.patch ];

=======
    hash = "sha256-vgjS8jAtLA2OvJG/pJAJnvaaMPMLkbKHgzIMsdzXTBM=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ python3Packages.setuptools ];

  pythonRelaxDeps = true;

  dependencies = with python3Packages; [
    about-time
    aiofiles
    aiohttp
    aiosignal
    alive-progress
    async-timeout
    attrs
    cddlparser
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    license = lib.licenses.cc0;
=======
    license = licenses.cc0;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [
      matthiasbeyer
      hemera
    ];
  };
}
