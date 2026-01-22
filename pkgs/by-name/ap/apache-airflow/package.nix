{
  fetchFromGitHub,
  fetchpatch,
  fetchPypi,
  python3,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = pySelf: pySuper: {
      connexion = pySuper.connexion.overridePythonAttrs rec {
        version = "2.14.2";
        src = fetchFromGitHub {
          owner = "spec-first";
          repo = "connexion";
          tag = version;
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
          pytest-tornasync
          pytestCheckHook
          testfixtures
        ];
        disabledTests = [
          "test_aiohttp_simple_api"
          "test_app"
          "test_invalid_type" # https://github.com/spec-first/connexion/issues/1969
          "test_openapi_yaml_behind_proxy"
          "test_run_with_wsgi_containers"
          "test_swagger_ui"
        ];
        postPatch = ''
          substituteInPlace connexion/__init__.py \
            --replace "2020.0.dev1" "${version}"
        '';
      };
      werkzeug = pySuper.werkzeug.overridePythonAttrs rec {
        version = "2.3.8";
        src = fetchPypi {
          pname = "werkzeug";
          inherit version;
          hash = "sha256-VUslfHS763oNJUFgpPj/4YUkP1KlIDUGC3Ycpi2XfwM=";
        };
        nativeCheckInputs = with pySelf; [
          pytest-xprocess
        ];
      };
      # flask's test-suite needs click 8.1.8
      #   TypeError: CliRunner.__init__() got an unexpected keyword argument 'mix_stderr'
      click = pySuper.click.overridePythonAttrs rec {
        version = "8.1.8";
        src = fetchPypi {
          pname = "click";
          inherit version;
          hash = "sha256-7VPJ2JkNg8Kifermjk7jN0c/YzDAQKMdQiXJV00WCWo=";
        };
      };
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
        pytestFlagsArray = [
          # tests that are marked with filterwarnings fail with
          # DeprecationWarning: 'pkgutil.get_loader' is deprecated and slated for
          # removal in Python 3.14; use importlib.util.find_spec() instead
          "-W ignore::DeprecationWarning"
        ];
      });
      flask-login = pySuper.flask-login.overridePythonAttrs rec {
        version = "0.6.3";
        src = fetchFromGitHub {
          owner = "maxcountryman";
          repo = "flask-login";
          tag = version;
          hash = "sha256-Sn7Ond67P/3+OmKKFE/KfA6FE4IajhiRXVVrXKJtY3I=";
        };
        nativeBuildInputs = with pySelf; [ setuptools ];
        pytestFlagsArray = [
          # DeprecationWarning: datetime.datetime.utcnow() is deprecated
          # and scheduled for removal in a future version.
          # Use timezone-aware objects to represent datetimes in UTC:
          # datetime.datetime.now(datetime.UTC).
          "-W ignore::DeprecationWarning"
        ];
      };
      flask-session = pySuper.flask-session.overridePythonAttrs rec {
        version = "0.5.0";
        src = fetchFromGitHub {
          owner = "palletc-eco";
          repo = "flask-session";
          tag = version;
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
      };
      # flask-appbuilder doesn't work with sqlalchemy 2.x, flask-appbuilder 3.x
      # https://github.com/dpgaspar/Flask-AppBuilder/issues/2038
      flask-appbuilder = pySuper.flask-appbuilder.overridePythonAttrs {
        meta.broken = false;
      };
      # a knock-on effect from overriding the sqlalchemy version
      flask-sqlalchemy = pySuper.flask-sqlalchemy.overridePythonAttrs {
        src = fetchPypi {
          pname = "Flask-SQLAlchemy";
          version = "2.5.1";
          hash = "sha256-K9pEtD58rLFdTgX/PMH4vJeTbMRkYjQkECv8LDXpWRI=";
        };
        format = "setuptools";
      };
      httpcore = pySuper.httpcore.overridePythonAttrs {
        # nullify upstream's pytest flags which cause
        # "TLS/SSL connection has been closed (EOF)"
        # with pytest-httpbin 1.x
        preCheck = ''
          substituteInPlace pyproject.toml \
            --replace '[tool.pytest.ini_options]' '[tool.notpytest.ini_options]'
        '';
      };
      pytest-httpbin = pySuper.pytest-httpbin.overridePythonAttrs rec {
        version = "1.0.2";
        src = fetchFromGitHub {
          owner = "kevin1024";
          repo = "pytest-httpbin";
          tag = "v${version}";
          hash = "sha256-S4ThQx4H3UlKhunJo35esPClZiEn7gX/Qwo4kE1QMTI=";
        };
        # Use unmerged PR #65 to fix older version:
        #   https://github.com/kevin1024/pytest-httpbin/pull/65/
        # It was closed in favour of another which isn't compatible with the overriden version.
        patches = [
          (fetchpatch {
            url = "https://github.com/kevin1024/pytest-httpbin/commit/4e325f877ff8f77dec9f380bd8e53bb42976775c.patch";
            hash = "sha256-a33XcdMupD+7ZzvUibePdldGImmPLDNU2sxRbwpveDA=";
          })
          (fetchpatch {
            url = "https://github.com/kevin1024/pytest-httpbin/commit/463afb9b200563ac6fe7ae535f7a7a3c818b0418.patch";
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
      };
      # apache-airflow doesn't work with sqlalchemy 2.x
      # https://github.com/apache/airflow/issues/28723
      sqlalchemy = pySuper.sqlalchemy_1_4;
      gitpython = pySuper.gitpython.overridePythonAttrs rec {
        version = "3.1.44";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = "gitpython";
          rev = version;
          hash = "sha256-KnKaBv/tKk4wiGWUWCEgd1vgrTouwUhqxJ1/nMjRaWk=";
        };
      };
      # ValueError: Unknown classifier in field `project.classifiers`: Programming Language :: Python :: Free Threading :: 2 - Beta
      urllib3 = pySuper.urllib3.overridePythonAttrs rec {
        version = "2.5.0";
        src = fetchPypi {
          pname = "urllib3";
          inherit version;
          hash = "sha256-P8R3M8fkGdS8P2s9wrT4kLt0OQajDVa6Slv6S7/5J2A=";
        };
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace-fail ', "setuptools-scm>=8,<9"' ""
        '';
      };
      smmap = pySuper.smmap.overridePythonAttrs rec {
        version = "5.0.2";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = "smmap";
          rev = "refs/tags/v${version}";
          hash = "sha256-0Y175kjv/8UJpSxtLpWH4/VT7JrcVPAq79Nf3rtHZZM=";
        };
      };
      trove-classifiers = pySuper.trove-classifiers.overridePythonAttrs rec {
        version = "2024.10.21.16";
        src = fetchPypi {
          pname = "trove_classifiers";
          inherit version;
          hash = "sha256-F8vQVdZ9Xp2d5jKTqHMpQ/q8IVdOTHt07fEStJKM9fM=";
        };
        postPatch = "";
      };
      packaging = pySuper.packaging.overridePythonAttrs rec {
        version = "24.2";
        src = fetchPypi {
          pname = "packaging";
          inherit version;
          hash = "sha256-wiim3F6TLTRrxXOTeRCdSeiFPdgiNXHHxbVSYO3AuX8=";
        };
      };
      pluggy = pySuper.pluggy.overridePythonAttrs rec {
        version = "1.5.0";
        src = fetchFromGitHub {
          owner = "pytest-dev";
          repo = "pluggy";
          tag = version;
          hash = "sha256-f0DxyZZk6RoYtOEXLACcsOn2B+Hot4U4g5Ogr/hKmOE=";
        };
      };
      pyproject-api = pySuper.pyproject-api.overridePythonAttrs rec {
        version = "1.8.0";
        src = fetchPypi {
          pname = "pyproject_api";
          inherit version;
          hash = "sha256-d7gEny/rXTPu/MIbV/HieWNid6isita1hxA3skN3hJY=";
        };
        disabledTests = [
          # AssertionError: assert ['magic>3', 'requests>2'] == ['magic >3', 'requests >2']
          "test_frontend_setuptools"
        ];
      };
      tox = pySuper.tox.overridePythonAttrs rec {
        version = "4.27.0";
        src = fetchFromGitHub {
          owner = "tox-dev";
          repo = "tox";
          tag = version;
          hash = "sha256-Z3qUK4w1ebPvdZD4ZuKgZXJPUu5lG0G41vn/pc9gC/0=";
        };
      };
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
