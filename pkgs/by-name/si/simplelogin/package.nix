{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  python3,
  makeBinaryWrapper,
  writeText,
}:

let
  alembicConfig = writeText "simplelogin-alembic.ini" ''
    [alembic]
    script_location = %(here)s/migrations

    [loggers]
    keys = root,sqlalchemy,alembic

    [handlers]
    keys = console

    [formatters]
    keys = generic

    [logger_root]
    level = WARN
    handlers = console
    qualname =

    [logger_sqlalchemy]
    level = WARN
    handlers =
    qualname = sqlalchemy.engine

    [logger_alembic]
    level = INFO
    handlers =
    qualname = alembic

    [handler_console]
    class = StreamHandler
    args = (sys.stderr,)
    level = NOTSET
    formatter = generic

    [formatter_generic]
    format = %(levelname)-5.5s [%(name)s] %(message)s
    datefmt = %H:%M:%S
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "simplelogin";
  version = "4.82.4";

  src = fetchFromGitHub {
    owner = "simple-login";
    repo = "app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0pZSf+A1MIGZx4lKpUatoaJIM3RYrXagt5k+GTjtCYQ=";
  };

  nativeBuildInputs = [
    python3.pkgs.wrapPython
    makeBinaryWrapper
  ];

  strictDeps = true;

  __structuredAttrs = true;

  pythonDeps = with python3.pkgs; [
    aiosmtpd
    aiospamc
    alembic
    arrow
    attrs
    bcrypt
    blinker
    boto3
    cachetools
    cbor2
    coloredlogs
    cryptography
    deprecated
    dkimpy
    dnspython
    email-validator
    facebook-sdk
    flanker
    flask
    flask-admin
    flask-cors
    flask-debugtoolbar
    flask-debugtoolbar-sqlalchemy
    flask-limiter
    flask-login
    flask-migrate
    flask-profiler
    flask-wtf
    gevent
    google-api-python-client
    google-auth-httplib2
    gunicorn
    ipython
    itsdangerous
    jwcrypto
    limits
    markupsafe
    memory-profiler
    newrelic
    newrelic-telemetry-sdk
    pgpy
    phpserialize
    psycopg2
    pycryptodome
    pyjwt
    pyopenssl
    pyotp
    pyre2
    pyspf
    python-dateutil
    python-dotenv
    python-gnupg
    redis
    requests
    requests-oauthlib
    sentry-sdk
    sl-pgp
    sqlalchemy
    sqlalchemy-utils
    standard-imghdr
    strictyaml
    tldextract
    twilio
    unidecode
    watchtower
    webauthn
    werkzeug
    wtforms
    yacron
  ];

  pythonPath = finalAttrs.pythonDeps;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    postPatch = "cd static";
    hash = "sha256-qLi0qZqInMUV3yaWQ2YvZ4UTfVFvkFwzRb2l/L01/fs=";
  };

  static = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-static";
    inherit (finalAttrs) version src npmDeps;
    npmRoot = "static";

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
    ];

    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';
  };

  patches = [
    ./re2-fallback.patch
    ./sqlalchemy-2-unmapped-annotation.patch
    ./sqlalchemy-2-migration.patch
    ./sqlalchemy-2-runtime-exec.patch
    ./upload-dir.patch
    ./wtforms-email-field.patch
    ./oauth-blueprint-name.patch
    ./flask-admin-theme.patch
    ./flask-blueprint-endpoints.patch
    ./arrowtype-timestamp.patch
    ./email-handler-listen-address.patch
  ];

  installPhase = ''
    runHook preInstall

    wrapPythonPrograms

    mkdir -p $out/share/${finalAttrs.pname} $out/bin
    cp -r app commands docs events local_data migrations monitor proto scripts static tasks templates *.py $out/share/${finalAttrs.pname}/
    rm -rf $out/share/${finalAttrs.pname}/static
    ln -s ${finalAttrs.static} $out/share/${finalAttrs.pname}/static
    cp ${alembicConfig} $out/share/${finalAttrs.pname}/alembic.ini

    for bin in web db-upgrade init-app email-handler job-runner event-listener monitoring; do
      case $bin in
        web) flag="-m gunicorn.app.wsgiapp wsgi:app" ;;
        db-upgrade) flag="-m alembic -c alembic.ini upgrade head" ;;
        init-app) flag="init_app.py" ;;
        email-handler) flag="email_handler.py" ;;
        job-runner) flag="job_runner.py" ;;
        event-listener) flag="event_listener.py" ;;
        monitoring) flag="monitoring.py" ;;
      esac
      makeWrapper ${python3.interpreter} $out/bin/${finalAttrs.pname}-$bin \
        --add-flags "$flag" \
        $extra \
        --set PYTHONPATH "$out/share/${finalAttrs.pname}:$program_PYTHONPATH" \
        --chdir "$out/share/${finalAttrs.pname}"
      unset extra flag
    done

    runHook postInstall
  '';

  passthru = {
    pythonPath = python3.pkgs.makePythonPath finalAttrs.pythonDeps;
  };

  meta = {
    description = "Email alias service for self-hosting";
    longDescription = ''
      SimpleLogin is an open-source email alias solution to protect your real
      email address. It lets you generate unique aliases that forward email to
      your real mailbox, keeping your identity private.
    '';
    homepage = "https://github.com/simple-login/app";
    changelog = "https://github.com/simple-login/app/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.agpl3Only;
    mainProgram = "simplelogin-web";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
