{ lib
, fetchurl
, nixosTests
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
, fetchFromGitHub
}:

let
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
in
python.pkgs.pythonPackages.buildPythonApplication rec {
  pname = "paperless-ngx";
  version = "1.11.3";

  # Fetch the release tarball instead of a git ref because it contains the prebuilt frontend
  src = fetchurl {
    url = "https://github.com/paperless-ngx/paperless-ngx/releases/download/v${version}/${pname}-v${version}.tar.xz";
    hash = "sha256-wGNkdczgV+UDd9ZO+BXMSWotpetE/+c/jJAAH+6SXps=";
  };

  format = "other";

  propagatedBuildInputs = with python.pkgs.pythonPackages; [
    aioredis
    arrow
    asgiref
    async-timeout
    attrs
    autobahn
    automat
    bleach
    blessed
    celery
    certifi
    cffi
    channels-redis
    channels
    chardet
    click
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
    django-picklefield
    django
    djangorestframework
    filelock
    fuzzywuzzy
    gunicorn
    h11
    hiredis
    httptools
    humanfriendly
    hyperlink
    imagehash
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
    nltk
    numpy
    ocrmypdf
    pathvalidate
    pdf2image
    pdfminer-six
    pikepdf
    pillow
    pluggy
    portalocker
    psycopg2
    pyasn1-modules
    pyasn1
    pycparser
    pyopenssl
    python-dateutil
    python-dotenv
    python-gnupg
    levenshtein
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
    six
    sortedcontainers
    sqlparse
    threadpoolctl
    tika
    tqdm
    twisted.optional-dependencies.tls
    txaio
    tzlocal
    urllib3
    uvicorn
    uvloop
    watchdog
    watchgod
    wcwidth
    websockets
    whitenoise
    whoosh
    zope_interface
  ];

  # Compile manually because `pythonRecompileBytecodeHook` only works for
  # files in `python.sitePackages`
  postBuild = ''
    ${python.interpreter} -OO -m compileall src
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -r . $out/lib/paperless-ngx
    chmod +x $out/lib/paperless-ngx/src/manage.py
    makeWrapper $out/lib/paperless-ngx/src/manage.py $out/bin/paperless-ngx \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PATH : "${path}"
    makeWrapper ${python.pkgs.celery}/bin/celery $out/bin/celery \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/lib/paperless-ngx/src" \
      --prefix PATH : "${path}"
  '';

  nativeCheckInputs = with python.pkgs.pythonPackages; [
    pytest-django
    pytest-env
    pytest-sugar
    pytest-xdist
    factory_boy
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
    inherit python path;
    tests = { inherit (nixosTests) paperless; };
  };

  meta = with lib; {
    description = "Tool to scan, index, and archive all of your physical documents";
    homepage = "https://paperless-ngx.readthedocs.io/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lukegb gador erikarvstedt ];
  };
}
