{
  lib,
  buildPythonApplication,
  substituteAll,
  fetchFromGitHub,
  isPy3k,
  colorama,
  flask,
  flask-httpauth,
  flask-socketio,
  stem,
  psutil,
  pyqt5,
  pycrypto,
  pyside2,
  pytestCheckHook,
  qrcode,
  qt5,
  requests,
  unidecode,
  tor,
  obfs4,
}:

let
  version = "2.3.3";
  src = fetchFromGitHub {
    owner = "micahflee";
    repo = "onionshare";
    rev = "v${version}";
    sha256 = "sha256-wU2020RNXlwJ2y9uzcLxIX4EECev1Z9YvNyiBalLj/Y=";
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
    maintainers = with maintainers; [ lourkeur ];
  };

in rec {
  onionshare = buildPythonApplication {
    pname = "onionshare-cli";
    inherit version meta;
    src = "${src}/cli";
    patches = [
      # hardcode store paths of dependencies
      (substituteAll {
        src = ./fix-paths.patch;
        inherit tor obfs4;
        inherit (tor) geoip;
      })
    ];
    disable = !isPy3k;
    propagatedBuildInputs = [
      colorama
      flask
      flask-httpauth
      flask-socketio
      stem
      psutil
      pycrypto
      requests
      unidecode
    ];

    buildInputs = [
      tor
      obfs4
    ];

    checkInputs = [
      pytestCheckHook
    ];

    preCheck = ''
      # Tests use the home directory
      export HOME="$(mktemp -d)"
    '';

    disabledTests = [
      "test_firefox_like_behavior"
      "test_if_unmodified_since"
    ];
  };

  onionshare-gui = buildPythonApplication {
    pname = "onionshare";
    inherit version meta;
    src = "${src}/desktop/src";
    patches = [
      # hardcode store paths of dependencies
      (substituteAll {
        src = ./fix-paths-gui.patch;
        inherit tor obfs4;
        inherit (tor) geoip;
      })
    ];

    disable = !isPy3k;
    propagatedBuildInputs = [
      onionshare
      pyqt5
      pyside2
      psutil
      qrcode
    ];

    nativeBuildInputs = [ qt5.wrapQtAppsHook ];

    preFixup = ''
      wrapQtApp $out/bin/onionshare
    '';

    doCheck = false;

    pythonImportsCheck = [ "onionshare" ];
  };
}
