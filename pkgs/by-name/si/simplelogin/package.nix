{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  python3,
  makeBinaryWrapper,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simplelogin";
  version = "4.80.3";

  src = fetchFromGitHub {
    owner = "simple-login";
    repo = "app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iPIiSbGWx/EHqCa6ICcpR5t5C7qGohaIB2yCuBnViag=";
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
    bcrypt
    blinker
    boto3
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
    pyopenssl
    pyotp
    pyre2
    pyspf
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
  ];

  installPhase = ''
    runHook preInstall

    wrapPythonPrograms

    mkdir -p $out/share/${finalAttrs.pname} $out/bin
    cp -r app commands docs events local_data migrations monitor proto scripts static tasks templates *.py $out/share/${finalAttrs.pname}/
    rm -rf $out/share/${finalAttrs.pname}/static
    ln -s ${finalAttrs.static} $out/share/${finalAttrs.pname}/static

    for bin in web db-upgrade init-app email-handler job-runner event-listener monitoring; do
      case $bin in
        web) flag="-m gunicorn.app.wsgiapp wsgi:app -b 0.0.0.0:7777 -w 2 --timeout 15" ;;
        db-upgrade) flag="-m flask db upgrade"; extra="--set FLASK_APP server.py" ;;
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
    tests = {
      inherit (nixosTests) simplelogin simplelogin-postfix;
    };
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
