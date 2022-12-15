{ lib
, buildPythonPackage
, fetchPypi
, pathvalidate
, text2digits
, pycountry
, beautifulsoup4
, importlib-metadata
, natsort
, pillow
, py7zr
, requests
, thefuzz
, typing-extensions
, wordninja
, unrar-cffi
, pyqt5
, wrapQtAppsHook
}:

buildPythonPackage rec {
  pname = "comicTagger";
  version = "1.5.0";

  src = fetchPypi {
    inherit version;
    pname = lib.strings.toLower pname;
    sha256 = "sha256-D42bGcHwzi2iT7qeTLlX5TXydqc5s+kTrWVioktwJ8s=";
  };

  doCheck = false;
  propagatedBuildInputs = [
    pathvalidate
    text2digits
    pycountry
    beautifulsoup4
    importlib-metadata
    natsort
    pillow
    py7zr
    requests
    thefuzz
    typing-extensions
    wordninja
    unrar-cffi
    pyqt5
  ];
  buildInputs = [
  ];
  nativeBuildInputs = [ wrapQtAppsHook ];

  meta = with lib; {
    homepage = "https://github.com/comictagger/comictagger";
    description = "A multi-platform app for writing metadata to digital comics";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexnortung ];
  };
}
