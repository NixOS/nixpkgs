{
  calibre,
  fetchFromGitLab,
  fetchPypi,
  ffmpeg-headless,
  lib,
  nix-update-script,
  python3Packages,
  calibreSupport ? true,
  ffmpegSupport ? true,
}:
let
  ez_setup = python3Packages.buildPythonPackage rec {
    pname = "ez_setup";
    version = "0.9";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-MDxbF9VS0eP7BQXYBUn4V59VfhPY3JDl7O88B9f1hkI=";
    };

    build-system = with python3Packages; [
      distutils
      setuptools
      wheel
    ];

    pythonImportsCheck = [
      "ez_setup"
    ];
  };

  slskd-api = python3Packages.buildPythonPackage rec {
    pname = "slskd-api";
    version = "0.1.5";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-LmWP7bnK5IVid255qS2NGOmyKzGpUl3xsO5vi5uJI88=";
    };

    build-system = with python3Packages; [
      setuptools
      setuptools-git-versioning
      wheel
    ];

    dependencies = with python3Packages; [
      requests
    ];

    pythonImportsCheck = [
      "slskd_api"
    ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "lazylibrarian";
  version = "2025.01.09-unstable-2025-07-08";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "LazyLibrarian";
    repo = "LazyLibrarian";
    rev = "d88acba6332ebcc517b1d071a27a0b5afe522c0f";
    hash = "sha256-HMoV9pLCdgppmSHJfJcpEWiogTJys1qIjeHvXpT+3fo=";
  };

  patches = [
    ./fix-setup.diff
  ];

  postPatch = ''
    mkdir -p src
    mv LazyLibrarian.py lazylibrarian lib data src
  '';

  build-system = with python3Packages; [
    ez_setup
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
      mako
      pillow
      pyopenssl
      pyparsing
      pypdf
      python-magic
      rapidfuzz
      requests
      tzdata
      urllib3
      webencodings
    ]
    ++ [ slskd-api ]
    ++ lib.optional calibreSupport [ calibre ]
    ++ lib.optional ffmpegSupport [ ffmpeg-headless ];

  pythonImportsCheck = [
    "lazylibrarian"
  ];

  makeWrapperArgs = [
    # Avoid automatic updates.
    "--set DOCKER 1"
    # Avoid `datadir` being on `/nix/store` by default.
    "--add-flags --datadir=\\$XDG_DATA_HOME/${meta.mainProgram}"
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
