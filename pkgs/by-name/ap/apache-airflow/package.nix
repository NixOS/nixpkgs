{
  fetchFromGitHub,
  fetchpatch,
  fetchPypi,
  python311,
}:

let
  python = python311.override {
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
      });
      # flask-appbuilder doesn't work with sqlalchemy 2.x, flask-appbuilder 3.x
      # https://github.com/dpgaspar/Flask-AppBuilder/issues/2038
      flask-appbuilder = pySuper.flask-appbuilder.overridePythonAttrs (o: {
        meta.broken = false;
      });
      flask-login = pySuper.flask-login.overridePythonAttrs (o: rec {
        version = "0.6.3";
        src = fetchPypi {
          pname = "Flask-Login";
          inherit version;
          hash = "sha256-XiPRSmB+8SgGxplZC4nQ8ODWe67sWZ11lHv5wUczAzM=";
        };
        nativeBuildInputs = [ pySelf.setuptools ];
      });
      # a knock-on effect from overriding the sqlalchemy version
      flask-sqlalchemy = pySuper.flask-sqlalchemy.overridePythonAttrs (o: {
        src = fetchPypi {
          pname = "Flask-SQLAlchemy";
          version = "2.5.1";
          hash = "sha256-K9pEtD58rLFdTgX/PMH4vJeTbMRkYjQkECv8LDXpWRI=";
        };
        format = "setuptools";
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
      pendulum = pySuper.pendulum.overridePythonAttrs (o: rec {
        version = "2.1.2";

        src = fetchPypi {
          inherit version;
          inherit (o) pname;
          sha256 = "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207";
        };
        postPatch = "";
        patches = [];

        preBuild = ''
          export HOME=$TMPDIR
        '';

        nativeBuildInputs = [];
        build-system = with pySelf; [ poetry-core ];
        dependencies = with pySelf; [ python-dateutil pytzdata ];

        # No tests
        doCheck = false;
      });
      pytest-httpbin = pySuper.pytest-httpbin.overridePythonAttrs (o: rec {
        version = "1.0.2";
        src = fetchFromGitHub {
          owner = "kevin1024";
          repo = "pytest-httpbin";
          rev = "refs/tags/v${version}";
          hash = "sha256-S4ThQx4H3UlKhunJo35esPClZiEn7gX/Qwo4kE1QMTI=";
        };
      });

      rich-argparse = pySuper.rich-argparse.overridePythonAttrs (o: {
        disabledTests = (o.disabledTests or []) ++ [ "test_generated_usage" ];
      });

      # apache-airflow doesn't work with sqlalchemy 2.x
      # https://github.com/apache/airflow/issues/28723
      sqlalchemy = pySuper.sqlalchemy_1_4;

      werkzeug = pySuper.werkzeug.overridePythonAttrs (o: rec {
        version = "2.2.3";
        pyproject = null;
        format = "setuptools";

        src = fetchPypi {
          pname = "Werkzeug";
          inherit version;
          hash = "sha256-LhzMlBfU2jWLnebxdOOsCUOR6h1PvvLWZ4ZdgZ39Cv4=";
        };

        patches = [
          (fetchpatch {
            url = "https://github.com/pallets/werkzeug/commit/4e5bdca7f8227d10cae828f8064fb98190ace4aa.patch";
            hash = "sha256-83doVvfdpymlAB0EbfrHmuoKE5B2LJbFq+AY2xGpnl4=";
          })
        ];

        nativeBuildInputs = [];

        propagatedBuildInputs = with pySelf; [
          markupsafe
        ] ++ lib.optionals (!stdenv.isDarwin) [
          # watchdog requires macos-sdk 10.13+
          watchdog
        ];

        nativeCheckInputs = with pySelf; [
          ephemeral-port-reserve
          pytest-timeout
          pytest-xprocess
          pytestCheckHook
        ];
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
