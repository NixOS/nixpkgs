{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, xcbuild
}:

let
  version = "1.17.2";
=======
}:

let
  version = "1.14.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "paperless-ngx";
    repo = "paperless-ngx";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-/0Ml3NRTghqNykB1RZfqDW9TtENnSRM7wqG7Vn4Kl04=";
=======
    hash = "sha256-9+8XqENpSdsND6g59oJkVoCe5tJ1Pwo8HD7Cszv/t7o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Use specific package versions required by paperless-ngx
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_4;
<<<<<<< HEAD
=======

      aioredis = super.aioredis.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0fi7jd5hlx8cnv1m97kv9hc4ih4l8v15wzkqwsp73is4n0qazy0m";
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
    npmDepsHash = "sha256-6EvC9Ka8gl0eRgJtHooB3yQNVGYzuH/WRga4AtzQ0EY=";

    nativeBuildInputs = [
      python3
    ] ++ lib.optionals stdenv.isDarwin [
      xcbuild
=======
    npmDepsHash = "sha256-XTk4DpQAU/rI2XoUvLm0KVjuXFWdz2wb2EAg8EBVEdU=";

    nativeBuildInputs = [
      python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];

    postPatch = ''
      cd src-ui
    '';

    CYPRESS_INSTALL_BINARY = "0";
    NG_CLI_ANALYTICS = "false";

    npmBuildFlags = [
      "--" "--configuration" "production"
    ];

<<<<<<< HEAD
    doCheck = true;
    checkPhase = ''
      runHook preCheck
      npm run test
      runHook postCheck
    '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    aioredis
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    daphne
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dateparser
    django-celery-results
    django-cors-headers
    django-compression-middleware
    django-extensions
    django-filter
    django-guardian
<<<<<<< HEAD
=======
    django-ipware
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    django
    djangorestframework-guardian2
    djangorestframework
    filelock
    gunicorn
    h11
    hiredis
    httptools
<<<<<<< HEAD
    httpx
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    numpy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ocrmypdf
    packaging
    pathvalidate
    pdf2image
<<<<<<< HEAD
=======
    pdfminer-six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    python-ipware
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    tika-client
=======
    tika
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    zxing_cpp
  ]
  ++ redis.optional-dependencies.hiredis
  ++ twisted.optional-dependencies.tls
  ++ uvicorn.optional-dependencies.standard;

  postBuild = ''
    # Compile manually because `pythonRecompileBytecodeHook` only works
    # for files in `python.sitePackages`
    ${python.pythonForBuild.interpreter} -OO -m compileall src

    # Collect static files
    ${python.pythonForBuild.interpreter} src/manage.py collectstatic --clear --no-input

    # Compile string translations using gettext
    ${python.pythonForBuild.interpreter} src/manage.py compilemessages
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
<<<<<<< HEAD
    daphne
    factory_boy
    imagehash
    pdfminer-six
    pytest-django
    pytest-env
    pytest-httpx
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    reportlab
=======
    factory_boy
    imagehash
    pytest-django
    pytest-env
    pytest-xdist
    pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
      --replace "--cov --cov-report=html --cov-report=xml" ""
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

<<<<<<< HEAD
  doCheck = !stdenv.isDarwin;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = {
    inherit python path frontend;
    tests = { inherit (nixosTests) paperless; };
  };

  meta = with lib; {
    description = "Tool to scan, index, and archive all of your physical documents";
    homepage = "https://docs.paperless-ngx.com/";
    changelog = "https://github.com/paperless-ngx/paperless-ngx/releases/tag/v${version}";
    license = licenses.gpl3Only;
<<<<<<< HEAD
    platforms = platforms.unix;
    maintainers = with maintainers; [ lukegb gador erikarvstedt leona ];
=======
    maintainers = with maintainers; [ lukegb gador erikarvstedt ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
