{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  linkFarm,
  callPackage,
  nixosTests,
  gettext,
  python3Packages,
  ghostscript_headless,
  imagemagickBig,
  jbig2enc,
  optipng,
  pngquant,
  qpdf,
  tesseract5,
  poppler-utils,
  liberation_ttf,
  symlinkJoin,
  nltk-data,
  lndir,
  nix-update-script,
  extraPythonPackageOverrides ? (_final: _prev: { }),
}:
let
  defaultPythonPackageOverrides = final: prev: {
    django = prev.django_5;

    # tesseract5 may be overwritten in the paperless module and we need to propagate that to make the closure reduction effective
    ocrmypdf = prev.ocrmypdf.override { tesseract = tesseract5; };
  };

  pythonPackages = python3Packages.overrideScope (
    final: prev:
    lib.composeManyExtensions [ defaultPythonPackageOverrides extraPythonPackageOverrides ] final prev
  );

  path = lib.makeBinPath [
    ghostscript_headless
    (imagemagickBig.override { ghostscript = ghostscript_headless; })
    jbig2enc
    optipng
    pngquant
    qpdf
    tesseract5
    poppler-utils
  ];

  nltkDataDir = symlinkJoin {
    name = "paperless-ngx-nltk-data";
    paths = with nltk-data; [
      punkt-tab
      snowball-data
      stopwords
    ];
  };

  # The paperless_ai want tiktoken's cl100k_base tokenizer. If not provided, they would try to download them and fail.
  # Seed tiktoken's on-disk cache instead so the tests can run and succeed offline; it keys cached files by sha1 of the download URL.
  tiktokenCacheDir = linkFarm "paperless-ngx-tiktoken-cache" [
    {
      name = "9b5ad71b2ce5302211f9c61530b329a4922fc6a4";
      path = fetchurl {
        url = "https://web.archive.org/web/20260723164258/https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken";
        hash = "sha256-Ijkht27pm96ZW3/3OFE+7xAPtR0YyTWXoRO8/+hlsqc=";
      };
    }
  ];
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "paperless-ngx";
  version = "3.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paperless-ngx";
    repo = "paperless-ngx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iTNl+TGs9NbbPl1Z+Y7z5DaBIv//Fcq21A9zhkmqIuw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"--numprocesses=auto",' "" \
      --replace-fail '--maxprocesses=16' "--numprocesses=$NIX_BUILD_CORES"
  '';

  build-system = [ pythonPackages.setuptools ];

  nativeBuildInputs = [
    gettext
    lndir
  ];

  pythonRelaxDeps = [
    "django-allauth"
    "django-filter"
    "drf-spectacular-sidecar"
    "redis"
    "regex"
    "torch"
    # requested by maintainer
    "imap-tools"
    "ocrmypdf"
    "filelock"
  ];

  dependencies =
    with pythonPackages;
    [
      azure-ai-documentintelligence
      babel
      bleach
      celery
      channels
      channels-redis
      concurrent-log-handler
      dateparser
      django
      django-allauth
      django-auditlog
      django-cachalot
      django-compression-middleware
      django-cors-headers
      django-extensions
      django-filter
      django-guardian
      django-multiselectfield
      django-rich
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
      ijson
      imap-tools
      jinja2
      langdetect
      llama-index-core
      llama-index-embeddings-huggingface
      llama-index-embeddings-ollama
      llama-index-embeddings-openai-like
      llama-index-llms-ollama
      llama-index-llms-openai-like
      mysqlclient
      nltk
      ocrmypdf
      openai
      pathvalidate
      pdf2image
      psycopg
      psycopg-pool
      python-dateutil
      python-dotenv
      python-gnupg
      python-ipware
      python-magic
      rapidfuzz
      redis
      regex
      scikit-learn
      sentence-transformers
      setproctitle
      sqlite-vec
      tantivy
      tika-client
      torch
      watchfiles
      whitenoise
      zxing-cpp
    ]
    ++ django-allauth.optional-dependencies.mfa
    ++ django-allauth.optional-dependencies.socialaccount
    ++ redis.optional-dependencies.hiredis;

  postBuild = ''
    # v3 rejects the default secret key at import, which the manage.py calls below hit.
    export PAPERLESS_SECRET_KEY=super-safe-secret-key

    # Compile manually because `pythonRecompileBytecodeHook` only works
    # for files in `python.sitePackages`
    ${pythonPackages.python.pythonOnBuildForHost.interpreter} -OO -m compileall src

    # Collect static files
    ${pythonPackages.python.pythonOnBuildForHost.interpreter} src/manage.py collectstatic --clear --no-input

    # Compile string translations using gettext
    ${pythonPackages.python.pythonOnBuildForHost.interpreter} src/manage.py compilemessages
  '';

  installPhase =
    let
      pythonPath = pythonPackages.makePythonPath finalAttrs.passthru.dependencies;
    in
    ''
      runHook preInstall

      mkdir -p $out/lib/paperless-ngx/static/frontend
      cp -r {src,static,LICENSE} $out/lib/paperless-ngx
      lndir -silent ${finalAttrs.passthru.frontend}/lib/paperless-ui/frontend $out/lib/paperless-ngx/static/frontend
      chmod +x $out/lib/paperless-ngx/src/manage.py
      makeWrapper $out/lib/paperless-ngx/src/manage.py $out/bin/paperless-ngx \
        --prefix PYTHONPATH : "${pythonPath}" \
        --prefix PATH : "${path}"
      makeWrapper ${lib.getExe pythonPackages.celery} $out/bin/celery \
        --prefix PYTHONPATH : "${pythonPath}:$out/lib/paperless-ngx/src" \
        --prefix PATH : "${path}"

      runHook postInstall
    '';

  postFixup = ''
    # Remove tests with samples (~14M)
    find $out/lib/paperless-ngx -type d -name tests -exec rm -rv {} +
  '';

  nativeCheckInputs = with pythonPackages; [
    daphne
    factory-boy
    faker
    imagehash
    pytest-cov-stub
    pytest-django
    pytest-env
    pytest-httpx
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    time-machine
  ];

  # manually managed in postPatch
  dontUsePytestXdist = false;

  enabledTestPaths = [
    "src"
  ];

  preCheck = ''
    # The tests require:
    # - PATH with runtime binaries
    # - A temporary HOME directory for gnupg
    # - XDG_DATA_DIRS with test-specific fonts
    export PATH="${path}:$PATH"
    export HOME=$(mktemp -d)
    export XDG_DATA_DIRS="${liberation_ttf}/share:$XDG_DATA_DIRS"
    export PAPERLESS_NLTK_DIR=${finalAttrs.passthru.nltkDataDir}
    # Limit threads per worker based on NIX_BUILD_CORES, capped at 256
    # ocrmypdf has an internal limit of 256 jobs and will fail with more:
    # https://github.com/ocrmypdf/OCRmyPDF/blob/66308c281306302fac3470f587814c3b212d0c40/src/ocrmypdf/cli.py#L234
    export PAPERLESS_THREADS_PER_WORKER=$(( NIX_BUILD_CORES > 256 ? 256 : NIX_BUILD_CORES ))

    # the generated pyc files conflict when running the tests
    rm -r build/lib
  ''
  # Use the seeded tiktoken cache so the paperless_ai tests tokenize offline, see above.
  # Gated to avoid the download on runs with tests disabled.
  + lib.optionalString finalAttrs.doInstallCheck ''
    export TIKTOKEN_CACHE_DIR=${tiktokenCacheDir}
  '';

  disabledTests = [
    # FileNotFoundError(2, 'No such file or directory'): /build/tmp...
    "test_script_with_output"
    "test_script_exit_non_zero"
    # Requires internet
    "test_send_webhook_data_or_json"
  ];

  disabledTestPaths = [
    # flaky test
    #   AssertionError: Expected 'apply_async' to not have been called.
    "src/documents/tests/test_management_consumer.py::TestCommandWatchEdgeCases::test_handles_deleted_before_stable"
    # flaky test:
    #   ValueError: Failed to open file for read: 'FileDoesNotExist("meta.json")'
    "src/documents/tests/test_permission_filtering_security.py::TestTrashRestorePermissionBoundary::test_restore_allows_document_with_explicit_delete_permission"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    frontend = callPackage ./frontend.nix {
      inherit (finalAttrs) src version;
      meta = removeAttrs finalAttrs.meta [ "mainProgram" ];
    };
    inherit
      nltkDataDir
      path
      tesseract5
      tiktokenCacheDir
      ;
    inherit (pythonPackages) python;
    tests = { inherit (nixosTests) paperless; };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "Tool to scan, index, and archive all of your physical documents";
    homepage = "https://docs.paperless-ngx.com/";
    changelog = "https://github.com/paperless-ngx/paperless-ngx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "paperless-ngx";
    maintainers = with lib.maintainers; [
      leona
      SuperSandro2000
      erikarvstedt
    ];
  };
})
