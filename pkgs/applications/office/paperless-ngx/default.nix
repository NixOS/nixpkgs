{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, nixosTests
, gettext
, python3
, ghostscript
, imagemagickBig
, jbig2enc
, optipng
, pngquant
, qpdf
, tesseract5
, unpaper
, poppler_utils
, liberation_ttf
, xcbuild
, pango
, pkg-config
, nltk-data
}:

let
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "paperless-ngx";
    repo = "paperless-ngx";
    rev = "refs/tags/v${version}";
    hash = "sha256-M1CnB1adk02lJuFsm0zzjSx/l9hKHJMt1Wh2a5Xtdyg=";
  };

  python = python3;

  path = lib.makeBinPath [
    ghostscript
    imagemagickBig
    jbig2enc
    optipng
    pngquant
    qpdf
    tesseract5
    unpaper
    poppler_utils
  ];

  frontend = buildNpmPackage {
    pname = "paperless-ngx-frontend";
    inherit version src;

    postPatch = ''
      cd src-ui
    '';

    npmDepsHash = "sha256-qgCUfGVk698Ink23U7LxkGdFoNpOhCp240tbk+hU0dk=";

    nativeBuildInputs = [
      pkg-config
      python3
    ] ++ lib.optionals stdenv.isDarwin [
      xcbuild
    ];

    buildInputs = [
      pango
    ];

    CYPRESS_INSTALL_BINARY = "0";
    NG_CLI_ANALYTICS = "false";

    npmBuildFlags = [
      "--" "--configuration" "production"
    ];

    doCheck = true;
    checkPhase = ''
      runHook preCheck
      npm run test
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/paperless-ui
      mv ../src/documents/static/frontend $out/lib/paperless-ui/
      runHook postInstall
    '';
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "paperless-ngx";
  format = "other";

  inherit version src;

  nativeBuildInputs = [
    gettext
  ];

  propagatedBuildInputs = with python.pkgs; [
    bleach
    channels
    channels-redis
    concurrent-log-handler
    dateparser
    django
    django-allauth
    django-auditlog
    django-celery-results
    django-compression-middleware
    django-cors-headers
    django-extensions
    django-filter
    django-guardian
    django-multiselectfield
    djangorestframework
    djangorestframework-guardian2
    drf-writable-nested
    filelock
    flower
    gotenberg-client
    gunicorn
    imap-tools
    inotifyrecursive
    langdetect
    mysqlclient
    nltk
    ocrmypdf
    pathvalidate
    pdf2image
    psycopg2
    python-dateutil
    python-dotenv
    python-gnupg
    python-ipware
    python-magic
    pyzbar
    rapidfuzz
    redis
    scikit-learn
    setproctitle
    tika-client
    tqdm
    uvicorn
    watchdog
    whitenoise
    whoosh
    zxing-cpp
  ]
  ++ redis.optional-dependencies.hiredis
  ++ uvicorn.optional-dependencies.standard;

  postBuild = ''
    # Compile manually because `pythonRecompileBytecodeHook` only works
    # for files in `python.sitePackages`
    ${python.pythonOnBuildForHost.interpreter} -OO -m compileall src

    # Collect static files
    ${python.pythonOnBuildForHost.interpreter} src/manage.py collectstatic --clear --no-input

    # Compile string translations using gettext
    ${python.pythonOnBuildForHost.interpreter} src/manage.py compilemessages
  '';

  installPhase = let
    pythonPath = python.pkgs.makePythonPath propagatedBuildInputs;
  in ''
    mkdir -p $out/lib/paperless-ngx
    cp -r {src,static,LICENSE,gunicorn.conf.py} $out/lib/paperless-ngx
    ln -s ${frontend}/lib/paperless-ui/frontend $out/lib/paperless-ngx/static/
    chmod +x $out/lib/paperless-ngx/src/manage.py
    makeWrapper $out/lib/paperless-ngx/src/manage.py $out/bin/paperless-ngx \
      --prefix PYTHONPATH : "${pythonPath}" \
      --prefix PATH : "${path}"
    makeWrapper ${python.pkgs.celery}/bin/celery $out/bin/celery \
      --prefix PYTHONPATH : "${pythonPath}:$out/lib/paperless-ngx/src" \
      --prefix PATH : "${path}"
  '';

  postFixup = ''
    # Remove tests with samples (~14M)
    find $out/lib/paperless-ngx -type d -name tests -exec rm -rv {} +
  '';

  nativeCheckInputs = with python.pkgs; [
    daphne
    factory-boy
    imagehash
    pytest-django
    pytest-env
    pytest-httpx
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src"
  ];

  # The tests require:
  # - PATH with runtime binaries
  # - A temporary HOME directory for gnupg
  # - XDG_DATA_DIRS with test-specific fonts
  preCheck = ''
    export PATH="${path}:$PATH"
    export HOME=$(mktemp -d)
    export XDG_DATA_DIRS="${liberation_ttf}/share:$XDG_DATA_DIRS"

    # Disable unneeded code coverage test
    substituteInPlace src/setup.cfg \
      --replace-fail "--cov --cov-report=html --cov-report=xml" ""
  '';

  disabledTests = [
    # FileNotFoundError(2, 'No such file or directory'): /build/tmp...
    "test_script_with_output"
    # AssertionError: 10 != 4 (timezone/time issue)
    # Due to getting local time from modification date in test_consumer.py
    "testNormalOperation"
  ];

  doCheck = !stdenv.isDarwin;

  passthru = {
    inherit python path frontend;
    nltkData = with nltk-data; [ punkt snowball_data stopwords ];
    tests = { inherit (nixosTests) paperless; };
  };

  meta = with lib; {
    description = "Tool to scan, index, and archive all of your physical documents";
    homepage = "https://docs.paperless-ngx.com/";
    changelog = "https://github.com/paperless-ngx/paperless-ngx/releases/tag/v${version}";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lukegb gador erikarvstedt leona ];
  };
}
