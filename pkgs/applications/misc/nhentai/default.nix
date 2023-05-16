<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "nhentai";
  version = "0.4.16";
<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "sha256-2lzrQqUx3lPM+OAUO/SwT+fAuG7kWmUnTACNUiP7d1M=";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    iso8601
    beautifulsoup4
    soupsieve
    tabulate
    future
  ];

  meta = with lib; {
    homepage = "https://github.com/RicterZ/nhentai";
    description = "nHentai is a CLI tool for downloading doujinshi from <http://nhentai.net>";
    license = licenses.mit;
    maintainers = with maintainers; [ travisdavis-ops ];
  };
}
