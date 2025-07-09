{
  calibre,
  fetchFromGitLab,
  ffmpeg-headless,
  lib,
  nix-update-script,
  python3Packages,
  calibreSupport ? true,
  ffmpegSupport ? true,
}:
python3Packages.buildPythonApplication {
  pname = "lazylibrarian";
  version = "2025.09.16-unstable-2026-04-30";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "LazyLibrarian";
    repo = "LazyLibrarian";
    rev = "322dba1ebc323274fb4a2a615597dad71d7856af";
    hash = "sha256-Kr6fOkIbQffxH1KDNuYzwB1ZgI8i/tc08gvyyNWRRW4=";
  };

  patches = [
    ./fix-setup.diff
  ];

  postPatch = ''
    mkdir -p src
    mv LazyLibrarian.py lazylibrarian lib data src
  '';

  build-system = with python3Packages; [
    ez-setup
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      apprise
      apscheduler
      beautifulsoup4
      cherrypy
      cherrypy-cors
      deluge-client
      html5lib
      httpagentparser
      httplib2
      irc
      iso639-lang
      lxml
      mako
      pillow
      pyopenssl
      pyparsing
      pypdf
      python-magic
      rapidfuzz
      requests
      slskd-api
      tzdata
      urllib3
      webencodings
      xmltodict
    ]
    ++ lib.optionals calibreSupport [ calibre ]
    ++ lib.optionals ffmpegSupport [ ffmpeg-headless ];

  pythonImportsCheck = [
    "lazylibrarian"
  ];

  makeWrapperArgs = [
    # Avoid automatic updates.
    "--set DOCKER 1"
    # Avoid `datadir` being on `/nix/store` by default.
    "--add-flags --datadir=\\$XDG_DATA_HOME/lazylibrarian"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Usenet/BitTorrent ebook, audiobook and magazine downloader";
    homepage = "https://lazylibrarian.gitlab.io/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ xelden ];
    mainProgram = "lazylibrarian";
  };
}
