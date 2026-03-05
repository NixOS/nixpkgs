{
  cypress,
  faketty,
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nix-update-script,
  nodejs,
  poetry,
  python3,
  yarnConfigHook,
}:
let
  python = python3.override {
    packageOverrides = final: prev: {
      django_5 = prev.django_5.overrideAttrs (old: rec {
        version = "5.1.15";
        src = fetchFromGitHub {
          owner = "django";
          repo = "django";
          tag = version;
          hash = "sha256-WrSEDBgW4sTe2sJyJKWv/rfueKM7osMRNNq9CjXopNk=";
        };
      });
      django = final.django_5;
      django-csp = prev.django-csp.overrideAttrs (old: rec {
        version = "3.8";
        src = fetchFromGitHub {
          owner = "mozilla";
          repo = "django-csp";
          tag = version;
          hash = "sha256-2LlUIG6nBPVDLZK9gEfAni9y0wItAUomqRiEjrNk4R8=";
        };
      });
      django-debug-toolbar = prev.django-debug-toolbar.overrideAttrs (old: rec {
        version = "6.0.0";
        src = fetchFromGitHub {
          owner = "django-commons";
          repo = "django-debug-toolbar";
          tag = version;
          hash = "sha256-WdoZ1nGsI/54Y/aVnMGO16/xBPlItv7zK/Y+fcv6iCg=";
        };
      });
      # django-rq >3.1 is incompatible, and we can't just override because of build system changes
      django-rq = prev.buildPythonPackage (old: rec {
        version = "3.1";
        pyproject = true;
        src = fetchFromGitHub {
          owner = "rq";
          repo = "django-rq";
          tag = "v${version}";
          hash = "sha256-TnOKgw52ykKcR0gHXcdYfv77js7I63PE1F3POdwJgvc=";
        };
        pname = "django-rq";

        build-system = [ prev.hatchling ];

        dependencies = [
          prev.django
          prev.redis
          prev.rq
        ];
      });
      launchdarkly-server-sdk = prev.launchdarkly-server-sdk.overrideAttrs (old: rec {
        version = "8.2.1";

        src = fetchFromGitHub {
          owner = "launchdarkly";
          repo = "python-server-sdk";
          tag = version;
          hash = "sha256-HVB/URZt0V6kFs8RJ1larSPTYDyMkmPQcstfa2f3sU8=";
        };

        build-system = [ prev.setuptools ];

        nativeBuildInputs = old.nativeBuildInputs ++ [ prev.setuptools ];

        disabledTests = old.disabledTests or [ ] ++ [
          # test invalid due to pyrfc3339 changes
          "test_operator[after-1970-01-01 00:00:02.500Z-1000-False]"
          # label-studio supports python >=3.10 <4, these tests use features removed in 3.12
          "test_cannot_connect_with_selfsigned_cert_by_default"
          "test_can_connect_with_selfsigned_cert_if_ssl_verify_is_false"
          "test_can_connect_with_selfsigned_cert_if_disable_ssl_verification_is_true"
          "test_can_connect_with_selfsigned_cert_by_setting_ca_certs"
        ];
      });
    };
  };
in

python.pkgs.buildPythonPackage rec {
  pname = "label_studio";
  version = "1.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HumanSignal";
    repo = "label-studio";
    tag = version;
    hash = "sha256-/OVYeLr5ZAIicO6WQObWN1fxE67wZGFyDszYQhLxKgk=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/web/yarn.lock";
    hash = "sha256-LCr15C/gfkdhZFwJbWUs1Lwp33ZWIgME/SK4hwObqTw=";
  };

  nativeBuildInputs = [
    faketty # needed for wrapping nx calls
    cypress
    poetry
    # frontend
    yarnConfigHook
    nodejs # needed for running package scripts
  ];

  dependencies = with python.pkgs; [
    appdirs
    attrs
    azure-storage-blob
    bleach
    boto3
    botocore
    colorama
    cryptography
    defusedxml
    django
    django-annoying
    django-cors-headers
    django-csp
    django-debug-toolbar
    django-environ
    django-extensions
    django-filter
    django-migration-linter
    django-model-utils
    django-ranged-fileresponse
    django-rq
    django-storages
    django-user-agents
    djangorestframework
    djangorestframework-simplejwt
    drf-dynamic-fields
    drf-flex-fields
    drf-generators
    drf-spectacular
    google-cloud-logging
    google-cloud-storage
    ijson
    label-studio-sdk
    launchdarkly-server-sdk
    lockfile
    lxml-html-clean
    numpy
    openai
    ordered-set
    pandas
    psycopg
    pyarrow
    pyboxen
    pydantic
    python-dateutil
    python-json-logger
    pytz
    pyyaml
    redis
    requests
    rq
    rules
    sentry-sdk
    setuptools
    tldextract
    ujson
    uuid-utils
    wheel
    xmljson
  ];

  pythonRelaxDeps = [
    "bleach"
    "drf-spectacular"
    "django-annoying"
    "django-cors-headers"
    "django-csp"
    "django-debug-toolbar"
    "django-environ"
    "django-extensions"
    "django-filter"
    "django-migration-linter"
    "django-model-utils"
    "django-storages"
    "djangorestframework"
    "drf-dynamic-fields"
    "drf-flex-fields"
    "drf-generators"
    "google-cloud-storage"
    "label-studio-sdk"
    "openai"
    "ordered-set"
    "pyarrow"
    "python-json-logger"
    "pytz"
    "redis"
    "rq"
    "rules"
    "wheel"
  ];

  pythonRemoveDeps = [
    "attr"
  ];

  nativeCheckInputs = with python.pkgs; [
    factory-boy
    fakeredis
    freezegun
    mock
    moto
    pytestCheckHook
    pytest-asyncio
    pytest-cov
    pytest-django
    pytest-env
    pytest-mock
    pytest-xdist
    python-box
    requests-mock
  ];

  env = {
    CYPRESS_INSTALL_BINARY = 0;
    # no internet
    LATEST_VERSION_CHECK = 0;
    COLLECT_ANALYTICS = "false";
    SENTRY_DSN = "";
    FRONTEND_SENTRY_DSN = "";
    SENTRY_RATE = 0;
    # setup db vars for check
    DJANGO_DB = "sqlite";
    DJANGO_SETTINGS_MODULE = "core.settings.label_studio";
    # checkPhase _pytest.pathlib.ImportPathMismatchError: ('label_studio.tests.conftest', '/build/source/label_studio/...
    PY_IGNORE_IMPORTMISMATCH = 1;
  };

  prePatch = ''
    # label_studio gets imported during buildPhase and it won't be available in importlib yet
    substituteInPlace label_studio/__init__.py --replace-fail "importlib.metadata.metadata(package_name).get('version')" "\"${version}\""
    substituteInPlace label_studio/tests/conftest.py label_studio/io_storages/tests/test_storage_prediction_validation.py label_studio/io_storages/tests/test_multitask_import.py --replace-fail "from moto import mock_s3" "from moto import mock_aws as mock_s3"
  '';

  configurePhase = ''
    runHook preConfigure

    pushd web

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    faketty yarn build
    popd

    PYTHONPATH=$PWD:$PYTHONPATH python label_studio/manage.py collectstatic
    poetry build

    runHook postBuild
  '';

  disabledTests = [
    # resolving DNS
    "test_local_url_after_redirect"
    "test_user_specified_block"
    "test_user_specified_block_without_default"
    "test_core_validate_upload_url[https://example.org-True-None]"
    "test_core_validate_upload_url[http://example.org-False-None]"
    # connecting to test.ml.backend.for.sdk.com
    "test_encode_returns_only_header_and_payload"
    "test_encode_full_returns_complete_jwt"
    "test_encode_vs_encode_full_comparison"
    "test_get_single_prediction_on_task"
    "test_get_multiple_predictions_on_task"
    "test_batch_predictions_single_prediction_per_task"
    "test_batch_predictions_multiple_predictions_per_task"
  ];

  preCheck = ''
    cd label_studio
  '';
  pytestFlags = [
    "-vv"
    "--import-mode=importlib"
    "--asyncio-mode=auto"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Label Studio is an open source data labeling tool";
    homepage = "https://github.com/HumanSignal/label-studio";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mrtipson ];
    changelog = "https://github.com/HumanSignal/label-studio/releases/tag/${src.tag}";
    mainProgram = "label-studio";
  };
}
