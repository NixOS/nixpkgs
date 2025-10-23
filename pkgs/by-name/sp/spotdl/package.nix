{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "spotdl";
  version = "4.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    tag = "v${version}";
    hash = "sha256-guQ8fIA20wtCkB5CkU7zg/INE+g8/fvQfIs5TNteQGo=";
  };

  build-system = with python3Packages; [ hatchling ];

  pythonRelaxDeps = true;

  dependencies =
    with python3Packages;
    [
      beautifulsoup4
      fastapi
      mutagen
      platformdirs
      pydantic
      pykakasi
      python-slugify
      pytube
      rapidfuzz
      requests
      rich
      soundcloud-v2
      spotipy
      syncedlyrics
      uvicorn
      websockets
      yt-dlp
      ytmusicapi
    ]
    ++ python-slugify.optional-dependencies.unidecode;

  nativeCheckInputs = with python3Packages; [
    pyfakefs
    pytest-mock
    pytest-subprocess
    pytest-vcr
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Tests require networking
    "tests/test_init.py"
    "tests/test_matching.py"
    "tests/providers/lyrics"
    "tests/types"
    "tests/utils/test_github.py"
    "tests/utils/test_m3u.py"
    "tests/utils/test_metadata.py"
    "tests/utils/test_search.py"
  ];

  disabledTests = [
    # Test require networking
    "test_convert"
    "test_download_ffmpeg"
    "test_download_song"
    "test_preload_song"
    "test_yt_get_results"
    "test_yt_search"
    "test_ytm_search"
    "test_ytm_get_results"
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  meta = {
    description = "Download your Spotify playlists and songs along with album art and metadata";
    homepage = "https://github.com/spotDL/spotify-downloader";
    changelog = "https://github.com/spotDL/spotify-downloader/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "spotdl";
  };
}
