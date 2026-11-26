{
  lib,
  callPackage,
  fetchFromGitHub,
  python3,
  uwsgi,
  ffmpeg,
  streamlink,
  vlc,
  nix-update-script,
  # sentence-transformers pulls in torch (~1 GiB); without it EPG auto-matching
  # falls back to fuzzy matching only.
  withMachineLearning ? false,
}:
let
  python = python3;

  # Upstream serves WSGI from uWSGI with gevent; nixpkgs doesn't build that plugin.
  uwsgi' =
    (uwsgi.override {
      plugins = [ "python3" ];
      python3 = python;
    }).overrideAttrs
      (old: {
        postBuild = (old.postBuild or "") + ''
          python3 uwsgiconfig.py --plugin plugins/gevent nixos gevent
        '';
      });

  # Only `cvlc` is used; skip the Qt GUI.
  vlc-headless = vlc.override {
    withQt5 = false;
    skins2Support = false;
  };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "dispatcharr";
  version = "0.34.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Dispatcharr";
    repo = "Dispatcharr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hOAzNLMFHAI2HSRZ5q2ogoc+FkAK4s1kYKjuV1NUd+0=";
  };

  postPatch = ''
    substituteInPlace dispatcharr/settings.py \
      --replace-fail 'MEDIA_ROOT = BASE_DIR / "media"' \
                     'MEDIA_ROOT = Path(os.environ.get("DISPATCHARR_MEDIA_ROOT", "/data/media"))'
    substituteInPlace apps/channels/tasks.py \
      --replace-fail '"/app/docker/comskip.ini"' "\"$out/share/dispatcharr/docker/comskip.ini\""
  '';

  dependencies =
    with python.pkgs;
    [
      celery
      channels
      channels-redis
      daphne
      django
      django-celery-beat
      django-cors-headers
      django-db-geventpool
      django-filter
      django-redis
      djangorestframework
      djangorestframework-simplejwt
      drf-spectacular
      gevent
      lxml
      m3u8
      packaging
      pillow
      psutil
      psycopg
      pytz
      rapidfuzz
      redis
      regex
      requests
      tzlocal
      yt-dlp
    ]
    ++ celery.optional-dependencies.redis
    ++ psycopg.optional-dependencies.c
    ++ lib.optional withMachineLearning sentence-transformers;

  env.DJANGO_SECRET_KEY = "build-only";

  buildPhase = ''
    runHook preBuild
    cp -r ${finalAttrs.passthru.frontend} frontend/dist
    python manage.py collectstatic --noinput
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app=$out/share/dispatcharr
    mkdir -p $app/docker $app/frontend
    cp -r apps core dispatcharr scripts static fixtures.json manage.py version.py $app/
    cp -r frontend/dist $app/frontend/
    cp docker/comskip.ini $app/docker/
    install -Dm755 manage.py $out/bin/dispatcharr-manage

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    "${placeholder "out"}/share/dispatcharr"
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath finalAttrs.passthru.runtimeDeps)
  ];

  passthru = {
    inherit python;
    uwsgi = uwsgi';
    runtimeDeps = [
      ffmpeg
      streamlink
      vlc-headless
    ];
    pythonPath = "${python.pkgs.makePythonPath finalAttrs.propagatedBuildInputs}:${finalAttrs.finalPackage}/share/dispatcharr";
    frontend = callPackage ./frontend.nix { inherit (finalAttrs) src version; };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "IPTV stream and EPG management service";
    homepage = "https://github.com/Dispatcharr/Dispatcharr";
    changelog = "https://github.com/Dispatcharr/Dispatcharr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mistyttm ];
    platforms = lib.platforms.all;
    mainProgram = "dispatcharr-manage";
  };
})
