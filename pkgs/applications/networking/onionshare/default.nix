{ lib
, stdenv
, buildPythonApplication
, substituteAll
, fetchFromGitHub
, isPy3k
, colorama
, flask
, flask-httpauth
, flask-socketio
, cepa
, psutil
, pyqt5
, pycrypto
, pynacl
, pyside2
, pysocks
, pytestCheckHook
, qrcode
, qt5
, requests
, unidecode
, tor
, obfs4
, snowflake
}:

let
  version = "2.6";
  src = fetchFromGitHub {
    owner = "onionshare";
    repo = "onionshare";
    rev = "v${version}";
    sha256 = "sha256-LA7XlzoCXUiG/9subTddAd22336wO9sOHCIBlQK4Ga4=";
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

  # TODO: package meek https://support.torproject.org/glossary/meek/
  meek = "/meek-not-available";

in
rec {
  onionshare = buildPythonApplication {
    pname = "onionshare-cli";
    inherit version meta;
    src = "${src}/cli";
    patches = [
      # hardcode store paths of dependencies
      (substituteAll {
        src = ./fix-paths.patch;
        inherit tor meek obfs4 snowflake;
        inherit (tor) geoip;
      })
    ];
    disable = !isPy3k;
    propagatedBuildInputs = [
      colorama
      flask
      flask-httpauth
      flask-socketio
      cepa
      psutil
      pycrypto
      pynacl
      requests
      unidecode
    ];

    buildInputs = [
      tor
      obfs4
    ];

    nativeCheckInputs = [
      pytestCheckHook
    ];

    preCheck = ''
      # Tests use the home directory
      export HOME="$(mktemp -d)"
    '';

    disabledTests = [
      "test_get_tor_paths_linux"  # expects /usr instead of /nix/store
    ] ++ lib.optionals stdenv.isDarwin [
      # on darwin (and only on darwin) onionshare attempts to discover
      # user's *real* homedir via /etc/passwd, making it more painful
      # to fake
      "test_receive_mode_webhook"
    ];
  };

  onionshare-gui = buildPythonApplication {
    pname = "onionshare";
    inherit version meta;
    src = "${src}/desktop";
    patches = [
      # hardcode store paths of dependencies
      (substituteAll {
        src = ./fix-paths-gui.patch;
        inherit tor meek obfs4 snowflake;
        inherit (tor) geoip;
      })
      ./fix-qrcode-gui.patch
    ];

    disable = !isPy3k;
    propagatedBuildInputs = [
      onionshare
      pyqt5
      pyside2
      psutil
      qrcode
      pysocks
    ];

    nativeBuildInputs = [ qt5.wrapQtAppsHook ];

    postInstall = ''
      mkdir -p $out/share/{appdata,applications,icons}
      cp $src/org.onionshare.OnionShare.desktop $out/share/applications
      cp $src/org.onionshare.OnionShare.svg $out/share/icons
      cp $src/org.onionshare.OnionShare.appdata.xml $out/share/appdata
    '';

    preFixup = ''
      wrapQtApp $out/bin/onionshare
    '';

    doCheck = false;

    pythonImportsCheck = [ "onionshare" ];
  };
}
