{ lib
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
}:

let
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "paperless-ngx";
    repo = "paperless-ngx";
    rev = "refs/tags/v${version}";
    hash = "sha256-1QufnRD2Nbc4twRZ4Yrf3ae1BRGves8tJ/M7coWnRPI=";
  };

  # Use specific package versions required by paperless-ngx
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_4;

      aioredis = super.aioredis.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0fi7jd5hlx8cnv1m97kv9hc4ih4l8v15wzkqwsp73is4n0qazy0m";
        };
      });

      # downgrade redis due to https://github.com/paperless-ngx/paperless-ngx/pull/1802
      # and https://github.com/django/channels_redis/issues/332
      channels-redis = super.channels-redis.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.1";
        src = fetchFromGitHub {
          owner = "django";
          repo = "channels_redis";
          rev = version;
          hash = "sha256-ZQSsE3pkM+nfDhWutNuupcyC5MDikUu6zU4u7Im6bRQ=";
        };
      });

      channels = super.channels.overridePythonAttrs (oldAttrs: rec {
        version = "3.0.5";
        pname = "channels";
        src = fetchFromGitHub {
          owner = "django";
          repo = pname;
          rev = version;
          sha256 = "sha256-bKrPLbD9zG7DwIYBst1cb+zkDsM8B02wh3D80iortpw=";
        };
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ self.daphne ];
        pytestFlagsArray = [ "--asyncio-mode=auto" ];
      });

      daphne = super.daphne.overridePythonAttrs (oldAttrs: rec {
        version = "3.0.2";
        pname = "daphne";
        src = fetchFromGitHub {
          owner = "django";
          repo = pname;
          rev = version;
          hash = "sha256-KWkMV4L7bA2Eo/u4GGif6lmDNrZAzvYyDiyzyWt9LeI=";
        };
      });
    };
  };

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

    npmDepsHash = "sha256-fp0Gy3018u2y6jaUM9bmXU0SVjyEJdsvkBqbmb8S10Y=";

    nativeBuildInputs = [
      python3
    ];

    postPatch = ''
      cd src-ui
    '';

    CYPRESS_INSTALL_BINARY = "0";
    NG_CLI_ANALYTICS = "false";

    npmBuildFlags = [
      "--" "--configuration" "production"
    ];

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
    aioredis
    amqp
    anyio
    asgiref
    async-timeout
    attrs
    autobahn
    automat
    billiard
    bleach
    celery
    certifi
    cffi
    channels-redis
    channels
    charset-normalizer
    click
    click-didyoumean
    click-plugins
    click-repl
    coloredlogs
    concurrent-log-handler
    constantly
    cryptography
    daphne
    dateparser
    django-celery-results
    django-cors-headers
    django-extensions
    django-filter
    django
    djangorestframework
    filelock
    gunicorn
    h11
    hiredis
    httptools
    humanfriendly
    humanize
    hyperlink
    idna
    imap-tools
    img2pdf
    incremental
    inotify-simple
    inotifyrecursive
    joblib
    langdetect
    lxml
    msgpack
    mysqlclient
    nltk
    numpy
    ocrmypdf
    packaging
    pathvalidate
    pdf2image
    pdfminer-six
    pikepdf
    pillow
    pluggy
    portalocker
    prompt-toolkit
    psycopg2
    pyasn1-modules
    pyasn1
    pycparser
    pyopenssl
    python-dateutil
    python-dotenv
    python-gnupg
    python-magic
    pytz
    pyyaml
    pyzbar
    rapidfuzz
    redis
    regex
    reportlab
    requests
    scikit-learn
    scipy
    service-identity
    setproctitle
    sniffio
    sqlparse
    threadpoolctl
    tika
    tornado
    tqdm
    twisted
    txaio
    tzdata
    tzlocal
    urllib3
    uvicorn
    uvloop
    vine
    watchdog
    watchfiles
    wcwidth
    webencodings
    websockets
    whitenoise
    whoosh
    zipp
    zope_interface
  ]
  ++ redis.optional-dependencies.hiredis
  ++ twisted.optional-dependencies.tls
  ++ uvicorn.optional-dependencies.standard;

  postBuild = ''
    # Compile manually because `pythonRecompileBytecodeHook` only works
    # for files in `python.sitePackages`
    ${python.interpreter} -OO -m compileall src

    # Collect static files
    ${python.interpreter} src/manage.py collectstatic --clear --no-input

    # Compile string translations using gettext
    ${python.interpreter} src/manage.py compilemessages
  '';

  installPhase = ''
    mkdir -p $out/lib/paperless-ngx
    cp -r {src,static,LICENSE,gunicorn.conf.py} $out/lib/paperless-ngx
    ln -s ${frontend}/lib/paperless-ui/frontend $out/lib/paperless-ngx/static/
    chmod +x $out/lib/paperless-ngx/src/manage.py
    makeWrapper $out/lib/paperless-ngx/src/manage.py $out/bin/paperless-ngx \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PATH : "${path}"
    makeWrapper ${python.pkgs.celery}/bin/celery $out/bin/celery \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/lib/paperless-ngx/src" \
      --prefix PATH : "${path}"
  '';

  postFixup = ''
    # Remove tests with samples (~14M)
    find $out/lib/paperless-ngx -type d -name tests -exec rm -rv {} +
  '';

  nativeCheckInputs = with python.pkgs; [
    factory_boy
    imagehash
    pytest-django
    pytest-env
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
      --replace "--cov --cov-report=html" ""
    # OCR on NixOS recognizes the space in the picture, upstream CI doesn't.
    # See https://github.com/paperless-ngx/paperless-ngx/pull/2216
    substituteInPlace src/paperless_tesseract/tests/test_parser.py \
      --replace "this is awebp document" "this is a webp document"
  '';

  disabledTests = [
    # FileNotFoundError(2, 'No such file or directory'): /build/tmp...
    "test_script_with_output"
    # AssertionError: 10 != 4 (timezone/time issue)
    # Due to getting local time from modification date in test_consumer.py
    "testNormalOperation"
  ];

  passthru = {
    inherit python path frontend;
    tests = { inherit (nixosTests) paperless; };
  };

  meta = with lib; {
    description = "Tool to scan, index, and archive all of your physical documents";
    homepage = "https://paperless-ngx.readthedocs.io/";
    changelog = "https://github.com/paperless-ngx/paperless-ngx/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lukegb gador erikarvstedt ];
  };
}
