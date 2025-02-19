{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_20,
  nixosTests,
  gettext,
  python3,
  giflib,
  darwin,
  ghostscript_headless,
  imagemagickBig,
  jbig2enc,
  optipng,
  pngquant,
  qpdf,
  tesseract5,
  unpaper,
  poppler_utils,
  liberation_ttf,
  xcbuild,
  pango,
  pkg-config,
  nltk-data,
  xorg,
}:
let
  version = "2.14.7";

  src = fetchFromGitHub {
    owner = "paperless-ngx";
    repo = "paperless-ngx";
    tag = "v${version}";
    hash = "sha256-p3eUEb/ZPK11NbqE4LU+3TE1Xny9sjfYvVVmABkoAEQ=";
  };

  # subpath installation is broken with uvicorn >= 0.26
  # https://github.com/NixOS/nixpkgs/issues/298719
  # https://github.com/paperless-ngx/paperless-ngx/issues/5494
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_5;

      django-extensions = prev.django-extensions.overridePythonAttrs (_: {
        # fails with: TypeError: 'class Meta' got invalid attribute(s): index_together
        # probably because of django_5 but it is the latest version available and used like that in paperless-ngx
        doCheck = false;
      });

      # tesseract5 may be overwritten in the paperless module and we need to propagate that to make the closure reduction effective
      ocrmypdf = prev.ocrmypdf.override { tesseract = tesseract5; };

      uvicorn = prev.uvicorn.overridePythonAttrs (_: {
        version = "0.25.0";
        src = fetchFromGitHub {
          owner = "encode";
          repo = "uvicorn";
          rev = "0.25.0";
          hash = "sha256-ng98DTw49zyFjrPnEwfnPfONyjKKZYuLl0qduxSppYk=";
        };
      });
    };
  };

  path = lib.makeBinPath [
    ghostscript_headless
    (imagemagickBig.override { ghostscript = ghostscript_headless; })
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

    nodejs = nodejs_20;  # does not build with 22

    postPatch = ''
      cd src-ui
    '';

    npmDepsHash = "sha256-hK7Soop9gBZP4m2UzbEIAsLkPKpbQkLmVruY2So4CSs=";

    nativeBuildInputs =
      [
        pkg-config
        python3
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        xcbuild
      ];

    buildInputs =
      [
        pango
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        giflib
        darwin.apple_sdk.frameworks.CoreText
      ];

    CYPRESS_INSTALL_BINARY = "0";
    NG_CLI_ANALYTICS = "false";

    npmBuildFlags = [
      "--"
      "--configuration"
      "production"
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
  pyproject = false;

  inherit version src;

  postPatch = ''
    # pytest-xdist with to many threads makes the tests flaky
    if (( $NIX_BUILD_CORES > 4)); then
      NIX_BUILD_CORES=4
    fi
    substituteInPlace src/setup.cfg \
      --replace-fail "--numprocesses auto --maxprocesses=16" "--numprocesses $NIX_BUILD_CORES"
  '';

  nativeBuildInputs = [
    gettext
    xorg.lndir
  ];

  dependencies =
    with python.pkgs;
    [
      bleach
      channels
      channels-redis
      concurrent-log-handler
      dateparser
      django_5
      django-allauth
      django-auditlog
      django-celery-results
      django-compression-middleware
      django-cors-headers
      django-extensions
      django-filter
      django-guardian
      django-multiselectfield
      django-soft-delete
      djangorestframework
      djangorestframework-guardian2
      drf-writable-nested
      filelock
      flower
      gotenberg-client
      gunicorn
      httpx-oauth
      imap-tools
      inotifyrecursive
      jinja2
      langdetect
      mysqlclient
      nltk
      ocrmypdf
      pathvalidate
      pdf2image
      psycopg
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
    ++ django-allauth.optional-dependencies.mfa
    ++ django-allauth.optional-dependencies.socialaccount
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

  installPhase =
    let
      pythonPath = python.pkgs.makePythonPath dependencies;
    in
    ''
      runHook preInstall

      mkdir -p $out/lib/paperless-ngx/static/frontend
      cp -r {src,static,LICENSE,gunicorn.conf.py} $out/lib/paperless-ngx
      lndir -silent ${frontend}/lib/paperless-ui/frontend $out/lib/paperless-ngx/static/frontend
      chmod +x $out/lib/paperless-ngx/src/manage.py
      makeWrapper $out/lib/paperless-ngx/src/manage.py $out/bin/paperless-ngx \
        --prefix PYTHONPATH : "${pythonPath}" \
        --prefix PATH : "${path}"
      makeWrapper ${lib.getExe python.pkgs.celery} $out/bin/celery \
        --prefix PYTHONPATH : "${pythonPath}:$out/lib/paperless-ngx/src" \
        --prefix PATH : "${path}"

      runHook postInstall
    '';

  postFixup = ''
    # Remove tests with samples (~14M)
    find $out/lib/paperless-ngx -type d -name tests -exec rm -rv {} +
  '';

  nativeCheckInputs = with python.pkgs; [
    daphne
    factory-boy
    imagehash
    pytest-cov-stub
    pytest-django
    pytest-env
    pytest-httpx
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
  ];

  # manually managed in postPatch
  dontUsePytestXdist = false;

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
  '';

  disabledTests = [
    # FileNotFoundError(2, 'No such file or directory'): /build/tmp...
    "test_script_with_output"
    "test_script_exit_non_zero"
    "testDocumentPageCountMigrated"
    # AssertionError: 10 != 4 (timezone/time issue)
    # Due to getting local time from modification date in test_consumer.py
    "testNormalOperation"
    # Something broken with new Tesseract and inline RTL/LTR overrides?
    "test_rtl_language_detection"
    # django.core.exceptions.FieldDoesNotExist: Document has no field named 'transaction_id'
    "test_convert"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    inherit
      python
      path
      frontend
      tesseract5
      ;
    nltkData = with nltk-data; [
      punkt_tab
      snowball_data
      stopwords
    ];
    tests = { inherit (nixosTests) paperless; };
  };

  meta = with lib; {
    description = "Tool to scan, index, and archive all of your physical documents";
    homepage = "https://docs.paperless-ngx.com/";
    changelog = "https://github.com/paperless-ngx/paperless-ngx/releases/tag/v${version}";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      leona
      SuperSandro2000
      erikarvstedt
    ];
  };
}
