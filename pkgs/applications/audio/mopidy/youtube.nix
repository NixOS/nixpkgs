{
  lib,
  fetchFromGitHub,
  python3,
  mopidy,
  yt-dlp,
  extraPkgs ? pkgs: [ ],
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

  propagatedBuildInputs =
    with python3.pkgs;
    [
      beautifulsoup4
      cachetools
      pykka
      requests
      ytmusicapi
    ]
    ++ [
      mopidy
      yt-dlp
    ]
    ++ extraPkgs pkgs;

  nativeCheckInputs = with python3.pkgs; [
    vcrpy
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace mopidy_youtube/youtube.py \
      --replace-fail 'youtube_dl_package = "youtube_dl"' 'youtube_dl_package = "yt_dlp"'
    substituteInPlace tests/conftest.py \
      --replace-fail 'import youtube_dl' 'import yt_dlp' \
      --replace-fail 'patcher = mock.patch.object(youtube, "youtube_dl", spec=youtube_dl)' \
      'patcher = mock.patch.object(youtube, "youtube_dl", spec=yt_dlp)' \
      --replace-fail '"youtube_dl_package": "youtube_dl",' '"youtube_dl_package": "yt_dlp",'
  '';

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
