{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,

  # patches
  replaceVars,
  meek,
  obfs4,
  snowflake,
  tor,

  fetchpatch,
  versionCheckHook,
  gitUpdater,
  onionshare-gui,
}:
python3Packages.buildPythonApplication rec {
  pname = "onionshare-cli";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onionshare";
    repo = "onionshare";
    rev = "refs/tags/v${version}";
    hash = "sha256-J8Hdriy8eWpHuMCI87a9a/zCR6xafM3A/Tkyom0Ktko=";
  };

  sourceRoot = "${src.name}/cli";

  patches = [
    # hardcode store paths of dependencies
    (replaceVars ./fix-paths.patch {
      inherit
        meek
        obfs4
        snowflake
        tor
        ;
      inherit (tor) geoip;
    })

    # Remove distutils for Python 3.12 compatibility
    # https://github.com/onionshare/onionshare/pull/1907
    (fetchpatch {
      url = "https://github.com/onionshare/onionshare/commit/1fb1a470df20d8a7576c8cf51213e5928528d59a.patch";
      includes = [ "onionshare_cli/onion.py" ];
      stripLen = 1;
      hash = "sha256-4XkqaEhMhvj6PyMssnLfXRazdP4k+c9mMDveho7pWg8=";
    })
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  pythonRelaxDeps = true;

  dependencies =
    with python3Packages;
    [
      cffi
      click
      colorama
      cython
      eventlet
      flask
      flask-compress
      flask-socketio
      gevent
      gevent-websocket
      packaging
      psutil
      pynacl
      pysocks
      qrcode
      requests
      setuptools
      stem
      unidecode
      urllib3
      waitress
      werkzeug
      wheel
    ]
    ++ requests.optional-dependencies.socks;

  buildInputs = [
    obfs4
    tor
  ];

  nativeCheckInputs =
    [
      versionCheckHook
    ]
    ++ (with python3Packages; [
      pytestCheckHook
    ]);

  preCheck = ''
    # Tests use the home directory
    export HOME="$(mktemp -d)"
  '';

  disabledTests =
    lib.optionals stdenv.hostPlatform.isLinux [
      "test_get_tor_paths_linux" # expects /usr instead of /nix/store
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # requires meek-client which is not packaged
      "test_get_tor_paths_darwin"
      # on darwin (and only on darwin) onionshare attempts to discover
      # user's *real* homedir via /etc/passwd, making it more painful
      # to fake
      "test_receive_mode_webhook"
    ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      inherit onionshare-gui;
    };
  };

  meta = {
    description = "Securely and anonymously send and receive files";
    longDescription = ''
      OnionShare is an open source tool for securely and anonymously sending
      and receiving files using Tor onion services. It works by starting a web
      server directly on your computer and making it accessible as an
      unguessable Tor web address that others can load in Tor Browser to
      download files from you, or upload files to you. It doesn't require
      setting up a separate server, using a third party file-sharing service,
      or even logging into an account.

      Unlike services like email, Google Drive, DropBox, WeTransfer, or nearly
      any other way people typically send files to each other, when you use
      OnionShare you don't give any companies access to the files that you're
      sharing. So long as you share the unguessable web address in a secure way
      (like pasting it in an encrypted messaging app), no one but you and the
      person you're sharing with can access the files.
    '';
    homepage = "https://onionshare.org/";
    changelog = "https://github.com/onionshare/onionshare/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bbjubjub ];
    mainProgram = "onionshare-cli";
  };
}
