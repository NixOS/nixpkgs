{
  lib,
  stdenv,
  fetchFromGitHub,
  node-gyp,
  nodejs_20,
  nixosTests,
  gettext,
  python3,
  giflib,
  ghostscript_headless,
  imagemagickBig,
  jbig2enc,
  optipng,
  pngquant,
  qpdf,
  tesseract5,
  unpaper,
  pnpm,
  poppler-utils,
  liberation_ttf,
  xcbuild,
  pango,
  pkg-config,
  nltk-data,
  xorg,
}:
let
  version = "2.17.1";

  src = fetchFromGitHub {
    owner = "paperless-ngx";
    repo = "paperless-ngx";
    tag = "v${version}";
    hash = "sha256-6FvP/HgomsPxqCtKrZFxMlD2fFyT2e/JII2L7ANiOao=";
  };

  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_5_1;

      # tesseract5 may be overwritten in the paperless module and we need to propagate that to make the closure reduction effective
      ocrmypdf = prev.ocrmypdf.override { tesseract = tesseract5; };
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
    poppler-utils
  ];

  frontend =
    let
      frontendSrc = src + "/src-ui";
    in
    stdenv.mkDerivation rec {
      pname = "paperless-ngx-frontend";
      inherit version;

      src = frontendSrc;

      pnpmDeps = pnpm.fetchDeps {
        inherit pname version src;
        hash = "sha256-VtYYwpMXPAC3g1OESnw3dzLTwiGqJBQcicFZskEucok=";
      };

      nativeBuildInputs =
        [
          node-gyp
          nodejs_20
          pkg-config
          pnpm.configHook
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
        ];

      CYPRESS_INSTALL_BINARY = "0";
      NG_CLI_ANALYTICS = "false";

      buildPhase = ''
        runHook preBuild

        pushd node_modules/canvas
        node-gyp rebuild
        popd

        pnpm run build --configuration production

        runHook postBuild
      '';

      doCheck = true;
      checkPhase = ''
        runHook preCheck

        pnpm run test

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
  pyproject = true;

  inherit version src;

  postPatch = ''
    # pytest-xdist with to many threads makes the tests flaky
    if (( $NIX_BUILD_CORES > 3)); then
      NIX_BUILD_CORES=3
    fi
    substituteInPlace pyproject.toml \
      --replace-fail '"--numprocesses=auto",' "" \
      --replace-fail '--maxprocesses=16' "--numprocesses=$NIX_BUILD_CORES" \
      --replace-fail "djangorestframework-guardian~=0.3.0" "djangorestframework-guardian2"
  '';

  nativeBuildInputs = [
    gettext
    xorg.lndir
  ];

  pythonRelaxDeps = [
    "django-allauth"
    "redis"
  ];

  dependencies =
    with python.pkgs;
    [
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
      django-soft-delete
      djangorestframework
      djangorestframework-guardian2
      drf-spectacular
      drf-spectacular-sidecar
      drf-writable-nested
      filelock
      flower
      gotenberg-client
      granian
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
      watchdog
      whitenoise
      whoosh-reloaded
      zxing-cpp
    ]
    ++ django-allauth.optional-dependencies.mfa
    ++ django-allauth.optional-dependencies.socialaccount
    ++ redis.optional-dependencies.hiredis;

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
      cp -r {src,static,LICENSE} $out/lib/paperless-ngx
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
    # Favicon tests fail due to static file handling in the test environment
    "test_favicon_view"
    "test_favicon_view_missing_file"
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
      punkt-tab
      snowball-data
      stopwords
    ];
    tests = { inherit (nixosTests) paperless; };
  };

  meta = {
    description = "Tool to scan, index, and archive all of your physical documents";
    homepage = "https://docs.paperless-ngx.com/";
    changelog = "https://github.com/paperless-ngx/paperless-ngx/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "paperless-ngx";
    maintainers = with lib.maintainers; [
      leona
      SuperSandro2000
      erikarvstedt
    ];
  };
}
