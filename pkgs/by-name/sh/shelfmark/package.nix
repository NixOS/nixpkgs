{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
  nixosTests,
  shelfmark-frontend,
  unrar-free,
}:

let
  pythonDeps = with python3Packages; [
    flask
    flask-cors
    flask-socketio
    python-socketio
    requests
    pysocks
    defusedxml
    beautifulsoup4
    tqdm
    dnspython
    gunicorn
    gevent
    gevent-websocket
    psutil
    emoji
    rarfile
    qbittorrent-api
    transmission-rpc
    authlib
    apprise
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shelfmark";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "calibrain";
    repo = "shelfmark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fe7zu51gFG2QgcBWcGkFi64CdZW4ohZg+7jdmeMFVLI=";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython
    makeWrapper
  ];

  pythonPath = pythonDeps;

  installPhase = ''
    runHook preInstall

    wrapPythonPrograms

    mkdir -p $out/libexec $out/bin

    cp -r shelfmark $out/libexec/shelfmark
    cp -r data $out/libexec/data
    ln -s ${finalAttrs.passthru.frontend} $out/libexec/frontend-dist

    makeWrapper ${python3Packages.python.interpreter} $out/bin/shelfmark \
      --prefix PATH : ${
        lib.makeBinPath [
          python3Packages.python
          unrar-free
        ]
      } \
      --set PYTHONPATH "$out/libexec:$program_PYTHONPATH" \
      --set USING_EXTERNAL_BYPASSER true \
      --add-flags "-m gunicorn.app.wsgiapp --worker-class geventwebsocket.gunicorn.workers.GeventWebSocketWorker --workers 1 -t 300 shelfmark.main:app"

    runHook postInstall
  '';

  passthru = {
    frontend = shelfmark-frontend.override {
      shelfmark = finalAttrs.finalPackage;
    };
    tests = {
      inherit (nixosTests) shelfmark;
    };
  };

  meta = {
    description = "Self-hosted web interface for searching and downloading books and audiobooks";
    homepage = "https://github.com/calibrain/shelfmark";
    changelog = "https://github.com/calibrain/shelfmark/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jamiemagee
      pyrox0
    ];
    mainProgram = "shelfmark";
  };
})
