{
  lib,
  stdenv,
  callPackage,
  python3,
  makeWrapper,
  nixosTests,
  unrar-free,
}:

let
  common = callPackage ./common.nix { };
  frontend = callPackage ./frontend.nix { };
  python = python3;

  pythonDeps = with python.pkgs; [
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
stdenv.mkDerivation {
  pname = "shelfmark";
  inherit (common) version src;

  nativeBuildInputs = [
    python.pkgs.wrapPython
    makeWrapper
  ];

  pythonPath = pythonDeps;

  installPhase = ''
    runHook preInstall

    # Call wrapPythonPrograms to populate $program_PYTHONPATH
    wrapPythonPrograms

    mkdir -p $out/share $out/bin

    # Copy Python application source
    cp -r shelfmark $out/share/shelfmark

    # Data files (e.g. book-languages.json) expected at PROJECT_ROOT/data/
    cp -r data $out/share/data

    # frontend-dist must be a sibling of shelfmark/ (PROJECT_ROOT detection)
    cp -r ${frontend} $out/share/frontend-dist

    # Create gunicorn launcher script
    cat > $out/bin/shelfmark <<'WRAPPER'
    #!/bin/sh
    exec python -m gunicorn.app.wsgiapp \
      --worker-class geventwebsocket.gunicorn.workers.GeventWebSocketWorker \
      --workers 1 \
      -t 300 \
      "$@" \
      shelfmark.main:app
    WRAPPER
    chmod +x $out/bin/shelfmark

    wrapProgram $out/bin/shelfmark \
      --prefix PATH : ${
        lib.makeBinPath [
          python.pkgs.python
          unrar-free
        ]
      } \
      --set PYTHONPATH "$out/share:$program_PYTHONPATH" \
      --set USING_EXTERNAL_BYPASSER true

    runHook postInstall
  '';

  passthru = {
    inherit frontend;
    pythonPath = python.pkgs.makePythonPath pythonDeps;
    tests.shelfmark = nixosTests.shelfmark;
  };

  meta = common.meta;
}
