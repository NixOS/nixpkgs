{
  lib,
  fetchFromGitHub,
  fetchpatch,
  fetchPypi,
  python3,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = pySelf: pySuper: {
      connexion = pySuper.connexion.overridePythonAttrs (o: rec {
        version = "2.14.2";
        src = fetchFromGitHub {
          owner = "spec-first";
          repo = "connexion";
          rev = "refs/tags/${version}";
          hash = "sha256-1v1xCHY3ZnZG/Vu9wN/it7rLKC/StoDefoMNs+hMjIs=";
        };
        nativeBuildInputs = with pySelf; [
          setuptools
        ];
        pythonRelaxDeps = [
          "werkzeug"
        ];
        propagatedBuildInputs = with pySelf; [
          aiohttp
          aiohttp-jinja2
          aiohttp-swagger
          clickclick
          flask
          inflection
          jsonschema
          openapi-spec-validator
          packaging
          pyyaml
          requests
          swagger-ui-bundle
        ];
        nativeCheckInputs = with pySelf; [
          aiohttp-remotes
          decorator
          pytest-aiohttp
          pytestCheckHook
          testfixtures
        ];
        disabledTests = [
          "test_app"
          "test_openapi_yaml_behind_proxy"
          "test_swagger_ui"
          "test_invalid_type" # https://github.com/spec-first/connexion/issues/1969
        ];
        postPatch = ''
          substituteInPlace connexion/__init__.py \
            --replace "2020.0.dev1" "${version}"
        '';
      });
      werkzeug = pySuper.werkzeug.overridePythonAttrs (o: rec {
        version = "2.3.8";
        src = fetchPypi {
          pname = "werkzeug";
          inherit version;
          hash = "sha256-VUslfHS763oNJUFgpPj/4YUkP1KlIDUGC3Ycpi2XfwM=";
        };
        nativeCheckInputs = with pySelf; [
          pytest-xprocess
        ];
      });
      flask = pySuper.flask.overridePythonAttrs (o: rec {
        version = "2.2.5";
        src = fetchPypi {
          pname = "Flask";
          inherit version;
          hash = "sha256-7e6bCn/yZiG9WowQ/0hK4oc3okENmbC7mmhQx/uXeqA=";
        };
        nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [
          pySelf.setuptools
        ];
        pytestFlagsArray = lib.optionals (python.pythonAtLeast "3.12") [
          # tests that are marked with filterwarnings fail with
          # DeprecationWarning: 'pkgutil.get_loader' is deprecated and slated for
          # removal in Python 3.14; use importlib.util.find_spec() instead
          "-W ignore::DeprecationWarning"
        ];
      });
      flask-login = pySuper.flask-login.overridePythonAttrs (o: rec {
        version = "0.6.3";
        src = fetchFromGitHub {
          owner = "maxcountryman";
          repo = "flask-login";
          rev = "refs/tags/${version}";
          hash = "sha256-Sn7Ond67P/3+OmKKFE/KfA6FE4IajhiRXVVrXKJtY3I=";
        };
        nativeBuildInputs = with pySelf; [ setuptools ];
        pytestFlagsArray = lib.optionals (python.pythonAtLeast "3.12") [
          # DeprecationWarning: datetime.datetime.utcnow() is deprecated
          # and scheduled for removal in a future version.
          # Use timezone-aware objects to represent datetimes in UTC:
          # datetime.datetime.now(datetime.UTC).
          "-W ignore::DeprecationWarning"
        ];
      });
      flask-session = pySuper.flask-session.overridePythonAttrs (o: rec {
        version = "0.5.0";
        src = fetchFromGitHub {
          owner = "palletc-eco";
          repo = "flask-session";
          rev = "refs/tags/${version}";
          hash = "sha256-t8w6ZS4gBDpnnKvL3DLtn+rRLQNJbrT2Hxm4f3+a3Xc=";
        };
        nativeCheckInputs = with pySelf; [ pytestCheckHook ];
        pytestFlagsArray = [
          "-k"
          "'null_session or filesystem_session'"
        ];
        dependencies = with pySelf; [
          flask-sqlalchemy
          cachelib
        ];
        disabledTests = [ ];
        disabledTestPaths = [ ];
        preCheck = "";
        postCheck = "";
      });
      # flask-appbuilder doesn't work with sqlalchemy 2.x, flask-appbuilder 3.x
      # https://github.com/dpgaspar/Flask-AppBuilder/issues/2038
      flask-appbuilder = pySuper.flask-appbuilder.overridePythonAttrs (o: {
        meta.broken = false;
      });
      # a knock-on effect from overriding the sqlalchemy version
      flask-sqlalchemy = pySuper.flask-sqlalchemy.overridePythonAttrs (o: {
        src = fetchPypi {
          pname = "Flask-SQLAlchemy";
          version = "2.5.1";
          hash = "sha256-K9pEtD58rLFdTgX/PMH4vJeTbMRkYjQkECv8LDXpWRI=";
        };
        nativeBuildInputs = with pySelf; [ pdm-pep517 ];
        format = "setuptools";
        disabledTests = [
          "test_persist_selectable"
        ];
      });
      httpcore = pySuper.httpcore.overridePythonAttrs (o: {
        # nullify upstream's pytest flags which cause
        # "TLS/SSL connection has been closed (EOF)"
        # with pytest-httpbin 1.x
        preCheck = ''
          substituteInPlace pyproject.toml \
            --replace '[tool.pytest.ini_options]' '[tool.notpytest.ini_options]'
        '';
      });
      pytest-httpbin = pySuper.pytest-httpbin.overridePythonAttrs (o: rec {
        version = "1.0.2";
        src = fetchFromGitHub {
          owner = "kevin1024";
          repo = "pytest-httpbin";
          rev = "refs/tags/v${version}";
          hash = "sha256-S4ThQx4H3UlKhunJo35esPClZiEn7gX/Qwo4kE1QMTI=";
        };
        # use unmerged PR #65 to fix
        # it was closed in favour of the other which isn't compatible with old version
        patches = [
          (fetchpatch {
            url = "https://github.com/kevin1024/pytest-httpbin/pull/65/commits/4e325f877ff8f77dec9f380bd8e53bb42976775c.patch";
            hash = "sha256-a33XcdMupD+7ZzvUibePdldGImmPLDNU2sxRbwpveDA=";
          })
          (fetchpatch {
            url = "https://github.com/kevin1024/pytest-httpbin/pull/65/commits/463afb9b200563ac6fe7ae535f7a7a3c818b0418.patch";
            hash = "sha256-HFmuLtAtEjnB6heSG1YNnqxtz2phXNkHbQaZyB5bLJs=";
          })
        ];
        disabledTests = [
          "test_httpbin_secure_accepts_get_requests"
          "test_httpbin_secure_accepts_lots_of_get_requests"
          "test_httpbin_both[https]"
          "test_chunked_encoding[https]"
          "TestClassBassedTests::test_http_secure"
          "test_dont_crash_on_certificate_problems"
          "test_redirect_location_is_https_for_secure_server"
          "test_httpbin_secure_accepts_get_requests"
          "test_http_secure"
        ];
      });
      # apache-airflow doesn't work with sqlalchemy 2.x
      # https://github.com/apache/airflow/issues/28723
      sqlalchemy = pySuper.sqlalchemy_1_4;
      gitdb = pySuper.gitdb.overridePythonAttrs (o: rec {
        version = "4.0.12";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = "gitdb";
          rev = "refs/tags/${version}";
          hash = "sha256-24nOiKHmrhdF0BAmx+1AxaDy8C+qlNFvpuZUyU+tMFU=";
        };
      });
      smmap = pySuper.smmap.overridePythonAttrs (o: rec {
        version = "5.0.2";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = "smmap";
          rev = "refs/tags/v${version}";
          hash = "sha256-0Y175kjv/8UJpSxtLpWH4/VT7JrcVPAq79Nf3rtHZZM=";
        };
      });
      trove-classifiers = pySuper.trove-classifiers.overridePythonAttrs (o: rec {
        version = "2024.10.21.16";
        src = fetchPypi {
          pname = "trove_classifiers";
          inherit version;
          hash = "sha256-F8vQVdZ9Xp2d5jKTqHMpQ/q8IVdOTHt07fEStJKM9fM=";
        };
      });
      packaging = pySuper.packaging.overridePythonAttrs (o: rec {
        version = "24.2";
        src = fetchPypi {
          pname = "packaging";
          inherit version;
          hash = "sha256-wiim3F6TLTRrxXOTeRCdSeiFPdgiNXHHxbVSYO3AuX8=";
        };
      });
      pluggy = pySuper.pluggy.overridePythonAttrs (o: rec {
        version = "1.5.0";
        src = fetchFromGitHub {
          owner = "pytest-dev";
          repo = "pluggy";
          tag = version;
          hash = "sha256-f0DxyZZk6RoYtOEXLACcsOn2B+Hot4U4g5Ogr/hKmOE=";
        };
      });
      pyproject-api = pySuper.pyproject-api.overridePythonAttrs (o: rec {
        version = "1.8.0";
        src = fetchPypi {
          pname = "pyproject_api";
          inherit version;
          hash = "sha256-d7gEny/rXTPu/MIbV/HieWNid6isita1hxA3skN3hJY=";
        };
      });
      apache-airflow = pySelf.callPackage ./python-package.nix { };
    };
  };
in
# See note in ./python-package.nix for
# instructions on manually testing the web UI
with python.pkgs;
(toPythonApplication apache-airflow).overrideAttrs (previousAttrs: {
  # Provide access to airflow's modified python package set
  # for the cases where external scripts need to import
  # airflow modules, though *caveat emptor* because many of
  # these packages will not be built by hydra and many will
  # not work at all due to the unexpected version overrides
  # here.
  passthru = (previousAttrs.passthru or { }) // {
    pythonPackages = python.pkgs;
  };
})
