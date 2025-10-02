{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
  pkgs,
  extraPkgs ? pkgs: [ ],
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-youtube";
  version = "3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natumbri";
    repo = "mopidy-youtube";
    tag = "v${version}";
    hash = "sha256-iFt7r8Ljymc+grNJiOClTHkZOeo7AcYpcNc8tLMPROk=";
  };

  postPatch = ''
    substituteInPlace mopidy_youtube/youtube.py \
      --replace-fail 'youtube_dl_package = "youtube_dl"' 'youtube_dl_package = "yt_dlp"'
    substituteInPlace tests/conftest.py \
      --replace-fail 'import youtube_dl' 'import yt_dlp' \
      --replace-fail 'patcher = mock.patch.object(youtube, "youtube_dl", spec=youtube_dl)' \
      'patcher = mock.patch.object(youtube, "youtube_dl", spec=yt_dlp)' \
      --replace-fail '"youtube_dl_package": "youtube_dl",' '"youtube_dl_package": "yt_dlp",'
  '';

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.beautifulsoup4
    pythonPackages.cachetools
    pythonPackages.pykka
    pythonPackages.requests
    pythonPackages.ytmusicapi
    pythonPackages.yt-dlp
  ]
  ++ extraPkgs pkgs; # should we remove this? If we do, don't forget to also change the docs!

  nativeCheckInputs = with pythonPackages; [
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

  pythonImportsCheck = [ "mopidy_youtube" ];

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube";
    homepage = "https://github.com/natumbri/mopidy-youtube";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
