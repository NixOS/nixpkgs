{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPypi,
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
  symlinkJoin,
  nltk-data,
  xorg,
}:
let
  version = "2.19.6";

  src = fetchFromGitHub {
    owner = "paperless-ngx";
    repo = "paperless-ngx";
    tag = "v${version}";
    hash = "sha256-nHLsA5hmAFkOAEQU/xD+hllwtc2SyBtns5auCNm9KNg=";
  };

  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_5_2;

      fido2 = prev.fido2.overridePythonAttrs {
        version = "1.2.0";

        src = fetchPypi {
          pname = "fido2";
          version = "1.2.0";
          hash = "sha256-45+VkgEi1kKD/aXlWB2VogbnBPpChGv6RmL4aqDTMzs=";
        };

        pytestFlags = [ ];
      };

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

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "paperless-ngx-frontend";
    inherit version;

    src = src + "/src-ui";

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-lxZOwt+/ReU7m7he0iJSt5HqaPkRksveCgvDG7uodjA=";
    };

    nativeBuildInputs = [
      node-gyp
      nodejs_20
      pkg-config
      pnpm.configHook
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xcbuild
    ];

    buildInputs = [
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

      # cat forcefully disables angular cli's spinner which doesn't work with nix' tty which is 0x0
      pnpm run build --configuration production | cat

      runHook postBuild
    '';

    doCheck = true;
    checkPhase = ''
      runHook preCheck

      pnpm run test | cat

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/paperless-ui
      mv ../src/documents/static/frontend $out/lib/paperless-ui/

      runHook postInstall
    '';
  });

  nltkDataDir = symlinkJoin {
    name = "paperless_ngx_nltk_data";
    paths = with nltk-data; [
      punkt-tab
      snowball-data
      stopwords
    ];
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
      --replace-fail '--maxprocesses=16' "--numprocesses=$NIX_BUILD_CORES"
  '';

  nativeBuildInputs = [
    gettext
    xorg.lndir
  ];

  pythonRelaxDeps = [
    "django-allauth"
    "django-cors-headers"
    "drf-spectacular-sidecar"
    "filelock"
    "ocrmypdf"
    "redis"
  ];

  dependencies =
    with python.pkgs;
    [
      babel
      bleach
      channels
      channels-redis
      concurrent-log-handler
      dateparser
      django
      # django-allauth version 65.9.X not yet supported
      # See https://github.com/paperless-ngx/paperless-ngx/issues/10336
      (django-allauth.overrideAttrs (
        new: prev: rec {
          version = "65.7.0";
          src = prev.src.override {
            tag = version;
            hash = "sha256-1HmEJ5E4Vp/CoyzUegqQXpzKUuz3dLx2EEv7dk8fq8w=";
          };
          patches = [ ];
        }
      ))
      django-auditlog
      django-cachalot
      django-celery-results
      django-compression-middleware
      django-cors-headers
      django-extensions
      django-filter
      django-guardian
      django-multiselectfield
      django-soft-delete
      django-treenode
      djangorestframework
      djangorestframework-guardian
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
      psycopg-pool
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

  enabledTestPaths = [
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
    export PAPERLESS_NLTK_DIR=${passthru.nltkDataDir}
    # Limit threads per worker based on NIX_BUILD_CORES, capped at 256
    # ocrmypdf has an internal limit of 256 jobs and will fail with more:
    # https://github.com/ocrmypdf/OCRmyPDF/blob/66308c281306302fac3470f587814c3b212d0c40/src/ocrmypdf/cli.py#L234
    export PAPERLESS_THREADS_PER_WORKER=$(( NIX_BUILD_CORES > 256 ? 256 : NIX_BUILD_CORES ))
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
    # Requires DNS
    "test_send_webhook_data_or_json"
    "test_workflow_webhook_send_webhook_retry"
    "test_workflow_webhook_send_webhook_task"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    inherit
      frontend
      nltkDataDir
      path
      python
      tesseract5
      ;
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
