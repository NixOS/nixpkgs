{
  fetchFromGitHub,
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
          "test_invalid_type"
          "test_openapi_yaml_behind_proxy"
          "test_swagger_ui"
        ];
        doCheck = false;
        postPatch = ''
          substituteInPlace connexion/__init__.py \
            --replace-fail "2020.0.dev1" "${version}"
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
        doCheck = false;
      });
      flask-login = pySuper.flask-login.overridePythonAttrs (o: rec {
        version = "0.6.2";
        src = fetchPypi {
          pname = "Flask-Login";
          inherit version;
          hash = "sha256-wKe6qf3ESM3T3W8JOd9y7sUXey96vmy4L8k00pyqycM=";
        };
        build-system = [ pySelf.setuptools ];
        doCheck = false;
        nativeBuildInputs = with pySelf; [
          semantic-version
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
      ## flask-appbuilder doesn't work with sqlalchemy 2.x, flask-appbuilder 3.x
      ## https://github.com/dpgaspar/Flask-AppBuilder/issues/2038
      flask-appbuilder = pySuper.flask-appbuilder.overridePythonAttrs (o: rec {
        version = "4.6.3";
        src = fetchPypi {
          pname = "Flask-AppBuilder";
          inherit version;
          hash = "sha256-jA3kRiDeHdjCNIWPG2WGPtlzu2ZFehDJ2FVhbRpxLD4=";
        };
        meta.broken = false;
        pythonImportsCheck = [ ];
      });
      ## a knock-on effect from overriding the sqlalchemy version
      flask-sqlalchemy = pySuper.flask-sqlalchemy.overridePythonAttrs (o: {
        src = fetchPypi {
          pname = "Flask-SQLAlchemy";
          version = "2.5.1";
          hash = "sha256-K9pEtD58rLFdTgX/PMH4vJeTbMRkYjQkECv8LDXpWRI=";
        };
        nativeBuildInputs = with pySelf; [ pdm-pep517 ];
        format = "setuptools";
        doCheck = false;
      });
      httpcore = pySuper.httpcore.overridePythonAttrs (o: {
        # nullify upstream's pytest flags which cause
        # "TLS/SSL connection has been closed (EOF)"
        # with pytest-httpbin 1.x
        preCheck = ''
          substituteInPlace pyproject.toml \
            --replace-fail '[tool.pytest.ini_options]' '[tool.notpytest.ini_options]'
        '';
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
        doCheck = false;
      });
      ## apache-airflow doesn't work with sqlalchemy 2.x
      ## https://github.com/apache/airflow/issues/28723
      sqlalchemy = pySuper.sqlalchemy_1_4;

      kerberos = pySuper.kerberos.overridePythonAttrs (o: {
        meta.broken = false;
      });
      gitpython = pySuper.gitpython.overridePythonAttrs (o: rec {
        version = "3.1.45";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = "GitPython";
          rev = "refs/tags/${version}";
          hash = "sha256-VHnuHliZEc/jiSo/Zi9J/ipAykj7D6NttuzPZiE8svM=";
        };
      });
      gitdb = pySuper.gitdb.overridePythonAttrs (o: rec {
        version = "4.0.12";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = "gitdb";
          rev = "refs/tags/${version}";
          hash = "sha256-24nOiKHmrhdF0BAmx+1AxaDy8C+qlNFvpuZUyU+tMFU=";
        };
      });
      hatchling = pySuper.hatchling.overridePythonAttrs (o: rec {
        pname = "hatchling";
        version = "1.27.0";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-lxwpbZgZq7OBERL8UsepdRyNOBiY82Uzuxb5eR6UH9Y=";
        };
      });
      pathspec = pySuper.pathspec.overridePythonAttrs (o: rec {
        version = "0.12.1";
        src = fetchFromGitHub {
          owner = "cpburnz";
          repo = "python-pathspec";
          rev = "refs/tags/v${version}";
          hash = "sha256-jv6uCN94LRfDy+583omvgmL96D2GcF8WhAM8V9ezH/0=";
        };
      });
      pluggy = pySuper.pluggy.overridePythonAttrs (o: rec {
        version = "1.6.0";
        src = fetchFromGitHub {
          owner = "pytest-dev";
          repo = "pluggy";
          rev = "refs/tags/${version}";
          hash = "sha256-pkQjPJuSASWmzwzp9H/UTJBQDr2r2RiofxpF135lAgc=";
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
        version = "2025.9.11.17";
        src = fetchPypi {
          inherit version;
          pname = "trove_classifiers";
          hash = "sha256-kxyphBpenJQIvCrme1DSis+FvvViGbVoYIdt0fLQJN0=";
        };
      });
      apache-airflow3 = pySelf.callPackage ./python-package.nix { };
    };
  };
in
with python.pkgs;
apache-airflow3.overrideAttrs (previousAttrs: {
  # Provide access to airflow's modified python package set
  # for the cases where external scripts need to import
  # airflow modules, though *caveat emptor* because many of
  # these packages will not be built by hydra and many will
  # not work at all due to the unexpected version overrides
  # here.
  passthru = (previousAttrs.passthru or { }) // {
    pythonPackages = python.pkgs;
  };

  shellHook = ''
    export PATH="${apache-airflow3.core}/bin:$PATH"
  '';
})
