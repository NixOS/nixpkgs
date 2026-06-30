{
  lib,
  fetchPypi,
  pythonPackages,
  mopidy,
  pkgs,
  extraPkgs ? pkgs: [ ],
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-youtube";
  version = "4.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "mopidy_youtube";
    inherit (finalAttrs) version;
    hash = "sha256-KgD6cE10efNPyP0XWkpSl386Vgw+ad7Ogqo96ZGJs7w=";
  };

  patches = [
    # https://github.com/natumbri/mopidy-youtube/pull/265
    ./fix-youtube-mopidy-4.patch
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

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.beautifulsoup4
    pythonPackages.cachetools
    pythonPackages.pykka
    pythonPackages.requests
    # Provides pkg_resources; remove when upstream replaces it.
    pythonPackages.setuptools_80
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

  meta = {
    description = "Mopidy extension for playing music from YouTube";
    homepage = "https://github.com/natumbri/mopidy-youtube";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
