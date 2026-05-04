{
  lib,
  python3,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  uwsgi,
}:

let
  python3Packages = python3.pkgs;
  mbdataCompat = python3Packages.mbdata.overridePythonAttrs (_: {
    version = "29.0.0";

    src = fetchFromGitHub {
      owner = "metabrainz";
      repo = "mbdata";
      tag = "v29.0.0";
      hash = "sha256-Fxec97dRLu0roz1DtyH2QAMYD672B4UA++QfGS9dyMM=";
    };
  });
  brainzutilsCompat = python3Packages.brainzutils.overridePythonAttrs (old: {
    dependencies = map (
      # Use mbdata compat here too
      dependency: if dependency == python3Packages.mbdata then mbdataCompat else dependency
    ) old.dependencies;
  });
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "listenbrainz";
  version = "2026-04-29.0";
  pyproject = false;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "listenbrainz-server";
    tag = "v-${finalAttrs.version}";
    hash = "sha256-GEJuqaLdOiUH7AR2GqpIcayGsllSAavOCUP/igGc8PQ=";
  };

  patches = [
    ./config-paths.patch
    ./static-root.patch
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-dLw3kKv1UZexwgooWJ5TYidiGbNovk9C/WTkSZ26exs=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  makeWrapperArgs = [
    "--set-default"
    "LISTENBRAINZ_CONFIG_FILE"
    "${placeholder "out"}/share/listenbrainz/config.py.sample"
    "--set-default"
    "LISTENBRAINZ_STATIC_ROOT"
    "${placeholder "out"}/share/listenbrainz/static"
  ];

  dependencies =
    with python3Packages;
    [
      beautifulsoup4
      bleach
      brainzutilsCompat
      click
      cryptography
      datasethoster
      feedgen
      flask
      flask-admin
      flask-debugtoolbar
      flask-htmx
      flask-login
      flask-socketio
      flask-sqlalchemy
      flask-wtf
      gevent
      gevent-websocket
      ijson
      internetarchive
      itsdangerous
      jinja2
      jsonschema
      kombu
      levenshtein
      markupsafe
      mbdataCompat
      more-itertools
      numpy
      orjson
      packaging
      pandas
      psycopg2-binary
      pyarrow
      pycountry
      pydantic_1
      pyjwt
      python-dateutil
      redis
      requests
      requests-oauthlib
      sentry-sdk
      spotipy
      sqlalchemy
      timeago
      troi
      typesense
      unidecode
      urllib3
      wtforms
      xmltodict
      yattag
    ]
    ++ [ uwsgi ];

  buildPhase = ''
    runHook preBuild
    npm run build:prod
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    sitePackages="$out/${python3Packages.python.sitePackages}"
    appRoot="$out/share/listenbrainz"
    staticRoot="$appRoot/static"

    mkdir -p "$sitePackages" "$appRoot" "$staticRoot" "$out/bin"

    cp -r listenbrainz listenbrainz_spark data manage.py run_websockets.py "$sitePackages/"
    install -Dm644 listenbrainz/config.py.sample "$sitePackages/listenbrainz/config.py"
    cp -r admin docs mbid_mapping "$appRoot/"
    install -Dm644 listenbrainz/config.py.sample "$appRoot/config.py.sample"

    cp -r frontend/dist frontend/fonts frontend/img frontend/sound "$staticRoot/"
    install -Dm644 frontend/robots.txt "$staticRoot/robots.txt"
    install -Dm644 frontend/favicon.ico "$staticRoot/favicon.ico"

    install -Dm755 ${./listenbrainz-web.py} "$out/bin/listenbrainz-web"
    install -Dm755 ${./listenbrainz-api-compat.py} "$out/bin/listenbrainz-api-compat"
    install -Dm755 ${./listenbrainz-websockets.py} "$out/bin/listenbrainz-websockets"
    install -Dm755 ${./listenbrainz-manage.py} "$out/bin/listenbrainz-manage"

    runHook postInstall
  '';

  pythonImportsCheck = [ "listenbrainz" ];

  meta = {
    description = "Open source music listening tracker and web service";
    downloadPage = "https://github.com/metabrainz/listenbrainz-server/releases";
    homepage = "https://listenbrainz.org";
    changelog = "https://github.com/metabrainz/listenbrainz-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    mainProgram = "listenbrainz-web";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
  };
})
