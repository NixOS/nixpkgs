{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  python314Packages,
  nix-update-script,
  makeWrapper,
  nixosTests,
  unrar-free,
  _experimental-update-script-combinators,
}:

let
  python3Packages = python314Packages;

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

  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "calibrain";
    repo = "shelfmark";
    tag = "v${version}";
    hash = "sha256-4x5HwVNNGmoJ/ey1+hc7IqgYjaEJjOWpFuqGlTc4MsM=";
  };

  frontend = buildNpmPackage (finalAttrs: {
    pname = "shelfmark-frontend";
    inherit version src;

    sourceRoot = "${finalAttrs.src.name}/src/frontend";

    npmDepsHash = "sha256-c/KDGUe+X4dfzbDXpkzYsEzvBxJjq46PTzqbgoCdGgw=";

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shelfmark";
  inherit version src;

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
    ln -s ${frontend} $out/libexec/frontend-dist

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
    inherit frontend;

    tests = {
      inherit (nixosTests) shelfmark;
    };

    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (nix-update-script {
        extraArgs = [
          "--subpackage=frontend"
          "--version=skip"
        ];
      })
    ];
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
