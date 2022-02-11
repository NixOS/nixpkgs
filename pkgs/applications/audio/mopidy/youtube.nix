{ lib
, fetchFromGitHub
, python3
, mopidy
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mopidy-youtube";
  version = "3.5";

  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "natumbri";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zn645rylr3wj45rg4mqrldibb5b24c85rdpcdc9d0a5q7528nl6";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    cachetools
    pykka
    requests
    youtube-dl
    ytmusicapi
  ] ++ [
    mopidy
  ];

  doCheck = false;

  pythonImportsCheck = [
    "mopidy_youtube"
  ];

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube";
    homepage = "https://github.com/natumbri/mopidy-youtube";
    license = licenses.asl20;
    maintainers = with maintainers; [ spwhitt ];
  };
}
