{ lib
, fetchFromGitHub
, python3
, mopidy
, extraPkgs ? pkgs: []
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mopidy-youtube";
  version = "3.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "natumbri";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iFt7r8Ljymc+grNJiOClTHkZOeo7AcYpcNc8tLMPROk=";
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
  ] ++ extraPkgs pkgs;

  nativeCheckInputs = with python3.pkgs; [
    vcrpy
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires a YouTube API key
    "test_get_default_config"
  ];

  disabledTestPaths = [
    # Disable tests which interact with Youtube
    "tests/test_api.py"
    "tests/test_backend.py"
    "tests/test_youtube.py"
  ];

  pythonImportsCheck = [
    "mopidy_youtube"
  ];

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube";
    homepage = "https://github.com/natumbri/mopidy-youtube";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
