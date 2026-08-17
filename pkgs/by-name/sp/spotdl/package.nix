{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "spotdl";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u5t8t9NJq+h/ujeLObKDCQG4brTqwdjSDslemmhePdc=";
  };

  build-system = with python3Packages; [ hatchling ];

  pythonRelaxDeps = true;

  dependencies =
    with python3Packages;
    [
      beautifulsoup4
      datastar-py
      fastapi
      jinja2
      mutagen
      platformdirs
      pydantic
      pykakasi
      python-multipart
      python-slugify
      rapidfuzz
      requests
      rich
      soundcloud-v2
      spotipy
      spotipyfree
      syncedlyrics
      uvicorn
      websockets
      yt-dlp
      ytmusicapi
    ]
    ++ python-slugify.optional-dependencies.unidecode
    ++ yt-dlp.optional-dependencies.default;

  nativeCheckInputs = with python3Packages; [
    pyfakefs
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    vcrpy
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
    # TypeError: 'LocalPath' object is not subscriptable
    "tests/utils/test_config.py"
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
    changelog = "https://github.com/spotDL/spotify-downloader/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "spotdl";
  };
})
