{
  lib,
  python3,
  fetchFromGitHub,
  ncurses,
}:

python3.pkgs.buildPythonApplication {
  pname = "swaglyrics";
  version = "1.2.2-unstable-2021-06-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SwagLyrics";
    repo = "SwagLyrics-For-Spotify";
    rev = "99fe764a9e45cac6cb9fcdf724c7d2f8cb4524fb";
    hash = "sha256-O48T1WsUIVnNQb8gmzSkFFHTOiFOKVSAEYhF9zUqZz0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "==" ">="
  '';

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    colorama
    flask
    requests
    swspotify
    unidecode
  ];

  nativeCheckInputs =
    with python3.pkgs;
    [
      blinker
      flask
      flask-testing
      mock
      pytestCheckHook
    ]
    ++ [
      ncurses
    ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Disable tests which touch network
    "test_database_for_unsupported_song"
    "test_that_lyrics_works_for_unsupported_songs"
    "test_that_get_lyrics_works"
    "test_lyrics_are_shown_in_tab"
    "test_songchanged_can_raise_songplaying"
  ];

  pythonImportsCheck = [
    "swaglyrics"
  ];

  meta = with lib; {
    description = "Lyrics fetcher for currently playing Spotify song";
    homepage = "https://github.com/SwagLyrics/SwagLyrics-For-Spotify";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "swaglyrics";
  };
}
