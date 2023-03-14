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
  version = "3.2.2";

  src = fetchPypi {
    inherit version;
    pname = "tcd";
    sha256 = "ee6a8e22c54ccfd29988554b13fe56b2a1bf524e110fa421d77e27baa8dcaa19";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pipenv==2022.4.30'," "" \
      --replace "setuptools==62.1." "setuptools" \
      --replace "requests==2.27.1" "requests" \
      --replace "twitch-python==0.0.20" "twitch-python" \
      --replace "pytz==2022.1" "pytz" \
      --replace "python-dateutil==2.8.2" "python-dateutil"
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
