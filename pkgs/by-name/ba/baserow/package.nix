{
  lib,
  fetchFromGitLab,
  makeWrapper,
  python3,
  antlr4_9,
}:

let

  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      antlr4-python3-runtime = super.antlr4-python3-runtime.override {
        antlr4 = antlr4_9;
      };

      baserow_premium = self.buildPythonPackage rec {
        pname = "baserow_premium";
        version = "1.12.1";
        format = "setuptools";

        src = fetchFromGitLab {
          owner = "bramw";
          repo = pname;
          rev = "refs/tags/${version}";
          hash = "sha256-zT2afl3QNE2dO3JXjsZXqSmm1lv3EorG3mYZLQQMQ2Q=";
        };

        sourceRoot = "${src.name}/premium/backend";

        doCheck = false;
      };

      django = super.django_3;
    };
  };
in

with python.pkgs;
buildPythonApplication rec {
  pname = "baserow";
  version = "1.12.1";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "bramw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zT2afl3QNE2dO3JXjsZXqSmm1lv3EorG3mYZLQQMQ2Q=";
  };

  sourceRoot = "${src.name}/backend";

  postPatch = ''
    # use input files to not depend on outdated peer dependencies
    mv requirements/base.{in,txt}
    mv requirements/dev.{in,txt}

    # remove dependency constraints
    sed -i requirements/base.txt \
      -e 's/[~<>=].*//' -i requirements/base.txt \
      -e 's/zope-interface/zope.interface/' \
      -e 's/\[standard\]//'
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = [
    autobahn
    advocate
    antlr4-python3-runtime
    boto3
    cached-property
    celery-redbeat
    channels
    channels-redis
    daphne
    dj-database-url
    django-celery-beat
    django-celery-email
    django-cors-headers
    django-health-check
    django-redis
    django-storages
    drf-jwt
    drf-spectacular
    faker
    gunicorn
    importlib-resources
    itsdangerous
    pillow
    pyparsing
    psutil
    psycopg2
    redis
    regex
    requests
    service-identity
    setuptools
    tqdm
    twisted
    unicodecsv
    uvicorn
    watchgod
    zipp
  ] ++ uvicorn.optional-dependencies.standard;

  postInstall = ''
    wrapProgram $out/bin/baserow \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix DJANGO_SETTINGS_MODULE : "baserow.config.settings.base"
  '';

  nativeCheckInputs = [
    baserow_premium
    boto3
    freezegun
    httpretty
    openapi-spec-validator
    pyinstrument
    pytestCheckHook
    pytest-django
    pytest-unordered
    responses
    zope-interface
  ];

  fixupPhase = ''
    cp -r src/baserow/contrib/database/{api,action,trash,formula,file_import} \
      $out/${python.sitePackages}/baserow/contrib/database/
    cp -r src/baserow/core/management/backup $out/${python.sitePackages}/baserow/core/management/
  '';

  disabledTests = [
    # Disable linting checks
    "flake8_plugins"
  ];

  disabledTestPaths = [
    # Disable premium tests
    "../premium/backend/src/baserow_premium"
    "../premium/backend/tests/baserow_premium"
    # Disable database related tests
    "tests/baserow/contrib/database"
    "tests/baserow/api"
    "tests/baserow/core"
    "tests/baserow/ws"
  ];

  DJANGO_SETTINGS_MODULE = "baserow.config.settings.test";

  meta = with lib; {
    description = "No-code database and Airtable alternative";
    homepage = "https://baserow.io";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    mainProgram = "baserow";
  };
}
