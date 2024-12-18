{ lib
, stdenv
, buildPythonApplication
, colorama
, fetchFromGitHub
, fetchpatch
, flask
, flask-compress
, flask-socketio
, gevent-websocket
, obfs4
, psutil
, packaging
, pycrypto
, pynacl
, pyside6
, pysocks
, pytestCheckHook
, qrcode
, qt5
, requests
, snowflake
, stem
, substituteAll
, tor
, unidecode
, waitress
, werkzeug
}:

let
  version = "2.6.2";
  src = fetchFromGitHub {
    owner = "onionshare";
    repo = "onionshare";
    rev = "v${version}";
    hash = "sha256-J8Hdriy8eWpHuMCI87a9a/zCR6xafM3A/Tkyom0Ktko=";
  };
  meta = with lib; {
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

    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bbjubjub ];
  };

  # TODO: package meek https://support.torproject.org/glossary/meek/
  meek = "/meek-not-available";

in
rec {
  onionshare = buildPythonApplication {
    pname = "onionshare-cli";
    inherit version;
    src = "${src}/cli";
    patches = [
      # hardcode store paths of dependencies
      (substituteAll {
        src = ./fix-paths.patch;
        inherit tor meek obfs4 snowflake;
        inherit (tor) geoip;
      })
    ];
    propagatedBuildInputs = [
      colorama
      flask
      flask-compress
      flask-socketio
      gevent-websocket
      packaging
      psutil
      pycrypto
      pynacl
      pyside6
      pysocks
      qrcode
      qrcode
      requests
      stem
      unidecode
      waitress
      werkzeug
    ] ++ requests.optional-dependencies.socks;

    buildInputs = [
      obfs4
      tor
    ];

    nativeCheckInputs = [
      pytestCheckHook
    ];

    preCheck = ''
      # Tests use the home directory
      export HOME="$(mktemp -d)"
    '';

    disabledTests = lib.optionals stdenv.isLinux [
      "test_get_tor_paths_linux"  # expects /usr instead of /nix/store
    ] ++ lib.optionals stdenv.isDarwin [
      # requires meek-client which is not packaged
      "test_get_tor_paths_darwin"
      # on darwin (and only on darwin) onionshare attempts to discover
      # user's *real* homedir via /etc/passwd, making it more painful
      # to fake
      "test_receive_mode_webhook"
    ];

    meta = meta // {
      mainProgram = "onionshare-cli";
    };
  };

  onionshare-gui = buildPythonApplication {
    pname = "onionshare";
    inherit version;
    src = "${src}/desktop";
    patches = [
      # hardcode store paths of dependencies
      (substituteAll {
        src = ./fix-paths-gui.patch;
        inherit tor meek obfs4 snowflake;
        inherit (tor) geoip;
      })

      # https://github.com/onionshare/onionshare/pull/1903
      (fetchpatch {
        url = "https://github.com/onionshare/onionshare/pull/1903/commits/f20db8fcbd18e51b58814ae8f98f3a7502b4f456.patch";
        stripLen = 1;
        hash = "sha256-wfIjdPhdUYAvbK5XyE1o2OtFOlJRj0X5mh7QQRjdyP0=";
      })
    ];

    propagatedBuildInputs = [
      onionshare
      pyside6
      qrcode
    ];

    nativeBuildInputs = [ qt5.wrapQtAppsHook ];

    buildInputs = [ qt5.qtwayland ];

    postInstall = ''
      mkdir -p $out/share/{appdata,applications,icons}
      cp $src/org.onionshare.OnionShare.desktop $out/share/applications
      cp $src/org.onionshare.OnionShare.svg $out/share/icons
      cp $src/org.onionshare.OnionShare.appdata.xml $out/share/appdata
    '';

    dontWrapQtApps = true;

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';

    doCheck = false;

    pythonImportsCheck = [ "onionshare" ];

    meta = meta // {
      mainProgram = "onionshare";
    };
  };
}
