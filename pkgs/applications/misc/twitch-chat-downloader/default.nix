{ lib
, buildPythonApplication
, fetchPypi
, requests
, twitch-python
, pytz
, python-dateutil
}:

buildPythonApplication rec {
  pname = "twitch-chat-downloader";
  version = "3.2.1";

  src = fetchPypi {
    inherit version;
    pname = "tcd";
    sha256 = "f9b5ea2ad3badb7deffdd9604368ccb54170cd7929efbaa2d7b534e089ae6338";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'pipenv>=2020.5.28'," ""
  '';

  propagatedBuildInputs = [ requests twitch-python pytz python-dateutil ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "tcd" ];

  meta = with lib; {
    description = "Twitch Chat Downloader";
    homepage = "https://github.com/PetterKraabol/Twitch-Chat-Downloader";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
