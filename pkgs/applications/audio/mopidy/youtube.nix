{ lib
, fetchFromGitHub
, python3
, mopidy
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mopidy-youtube";
  version = "3.4";

  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "natumbri";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lm6nn926qkrwzvj64yracdixfrnv5zk243msjskrnlzkhgk01rk";
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

  checkInputs = with python3.pkgs; [
    vcrpy
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires a YouTube API key
    "test_get_default_config"
  ];

  disabledTestPaths = [
    # Fails with an import error
    "tests/test_backend.py"
  ];

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
