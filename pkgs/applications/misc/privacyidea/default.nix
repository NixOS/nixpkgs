{ lib, fetchFromGitHub, cacert, openssl, nixosTests
, python310, fetchpatch
}:

let
  dropDevOutput = { outputs, ... }: {
    outputs = lib.filter (x: x != "doc") outputs;
  };

  python3' = python310.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.24";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };
        doCheck = false;
      });
      # fails with `no tests ran in 1.75s`
      alembic = super.alembic.overridePythonAttrs (lib.const {
        doCheck = false;
      });
      flask_migrate = super.flask_migrate.overridePythonAttrs (oldAttrs: rec {
        version = "2.7.0";
        src = self.fetchPypi {
          pname = "Flask-Migrate";
          inherit version;
          sha256 = "ae2f05671588762dd83a21d8b18c51fe355e86783e24594995ff8d7380dffe38";
        };
      });
      flask-sqlalchemy = super.flask-sqlalchemy.overridePythonAttrs (old: rec {
        version = "2.5.1";
        format = "setuptools";
        src = self.fetchPypi {
          pname = "Flask-SQLAlchemy";
          inherit version;
          hash = "sha256:2bda44b43e7cacb15d4e05ff3cc1f8bc97936cc464623424102bfc2c35e95912";
        };
      });
      # Taken from by https://github.com/NixOS/nixpkgs/pull/173090/commits/d2c0c7eb4cc91beb0a1adbaf13abc0a526a21708
      werkzeug = super.werkzeug.overridePythonAttrs (old: rec {
        version = "1.0.1";
        src = old.src.override {
          inherit version;
          sha256 = "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c";
        };
        nativeCheckInputs = old.nativeCheckInputs ++ (with self; [
          requests
        ]);
        doCheck = false;
      });
      # Required by flask-1.1
      jinja2 = super.jinja2.overridePythonAttrs (old: rec {
        version = "2.11.3";
        src = old.src.override {
          inherit version;
          sha256 = "sha256-ptWEM94K6AA0fKsfowQ867q+i6qdKeZo8cdoy4ejM8Y=";
        };
        patches = [
          # python 3.10 compat fixes. In later upstream releases, but these
          # are not compatible with flask 1 which we need here :(
          (fetchpatch {
            url = "https://github.com/thmo/jinja/commit/1efb4cc918b4f3d097c376596da101de9f76585a.patch";
            sha256 = "sha256-GFaSvYxgzOEFmnnDIfcf0ImScNTh1lR4lxt2Uz1DYdU=";
          })
          (fetchpatch {
            url = "https://github.com/mkrizek/jinja/commit/bd8bad37d1c0e2d8995a44fd88e234f5340afec5.patch";
            sha256 = "sha256-Uow+gaO+/dH6zavC0X/SsuMAfhTLRWpamVlL87DXDRA=";
            excludes = [ "CHANGES.rst" ];
          })
        ];
      });
      # Required by jinja2-2.11.3
      markupsafe = super.markupsafe.overridePythonAttrs (old: rec {
        version = "2.0.1";
        src = old.src.override {
          inherit version;
          sha256 = "sha256-WUxngH+xYjizDES99082wCzfItHIzake+KDtjav1Ygo=";
        };
      });
      itsdangerous = super.itsdangerous.overridePythonAttrs (old: rec {
        version = "1.1.0";
        src = old.src.override {
          inherit version;
          sha256 = "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19";
        };
      });
      flask = super.flask.overridePythonAttrs (old: rec {
        version = "1.1.4";
        src = old.src.override {
          inherit version;
          sha256 = "0fbeb6180d383a9186d0d6ed954e0042ad9f18e0e8de088b2b419d526927d196";
        };
      });
      sqlsoup = super.sqlsoup.overrideAttrs ({ meta ? {}, ... }: {
        meta = meta // { broken = false; };
      });
      click = super.click.overridePythonAttrs (old: rec {
        version = "7.1.2";
        src = old.src.override {
          inherit version;
          sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a";
        };
      });
      # Now requires `lingua` as check input that requires a newer `click`,
      # however `click-7` is needed by the older flask we need here. Since it's just
      # for the test-suite apparently, let's skip it for now.
      Mako = super.Mako.overridePythonAttrs (lib.const {
        nativeCheckInputs = [];
        doCheck = false;
      });
      # Requires pytest-httpserver as checkInput now which requires Werkzeug>=2 which is not
      # supported by current privacyIDEA.
      responses = super.responses.overridePythonAttrs (lib.const {
        doCheck = false;
      });
      flask-babel = (super.flask-babel.override {
        sphinxHook = null;
        furo = null;
      }).overridePythonAttrs (old: (dropDevOutput old) // rec {
        pname = "Flask-Babel";
        version = "2.0.0";
        format = "setuptools";
        src = self.fetchPypi {
          inherit pname;
          inherit version;
          hash = "sha256:f9faf45cdb2e1a32ea2ec14403587d4295108f35017a7821a2b1acb8cfd9257d";
        };
      });
      psycopg2 = (super.psycopg2.override {
        sphinxHook = null;
        sphinx-better-theme = null;
      }).overridePythonAttrs dropDevOutput;
      hypothesis = super.hypothesis.override {
        enableDocumentation = false;
      };
      pyjwt = (super.pyjwt.override {
        sphinxHook = null;
        sphinx-rtd-theme = null;
      }).overridePythonAttrs (old: (dropDevOutput old) // { format = "setuptools"; });
      beautifulsoup4 = (super.beautifulsoup4.override {
        sphinxHook = null;
      }).overridePythonAttrs dropDevOutput;
      pydash = (super.pydash.override {
        sphinx-rtd-theme = null;
      }).overridePythonAttrs (old: rec {
        version = "5.1.0";
        src = self.fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-GysFCsG64EnNB/WSCxT6u+UmOPSF2a2h6xFanuv/aDU=";
        };
        format = "setuptools";
        doCheck = false;
      });
    };
  };
in
python3'.pkgs.buildPythonPackage rec {
  pname = "privacyIDEA";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SYXw8PBCb514v3rcy15W/vZS5JyMsu81D2sJmviLRtw=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = with python3'.pkgs; [
    cryptography pyrad pymysql python-dateutil flask-versioned flask_script
    defusedxml croniter flask_migrate pyjwt configobj sqlsoup pillow
    python-gnupg passlib pyopenssl beautifulsoup4 smpplib flask-babel
    ldap3 huey pyyaml qrcode oauth2client requests lxml cbor2 psycopg2
    pydash ecdsa google-auth importlib-metadata argon2-cffi bcrypt segno
  ];

  passthru.tests = { inherit (nixosTests) privacyidea; };

  nativeCheckInputs = with python3'.pkgs; [ openssl mock pytestCheckHook responses testfixtures ];
  preCheck = "export HOME=$(mktemp -d)";
  postCheck = "unset HOME";
  disabledTests = [
    # expects `/home/` to exist, fails with `FileNotFoundError: [Errno 2] No such file or directory: '/home/'`.
    "test_01_loading_scripts"

    # Tries to connect to `fcm.googleapis.com`.
    "test_02_api_push_poll"
    "test_04_decline_auth_request"

    # Timezone info not available in build sandbox
    "test_14_convert_timestamp_to_utc"

    # Fails because of different logger configurations
    "test_01_create_default_app"
    "test_03_logging_config_file"
    "test_04_logging_config_yaml"
    "test_05_logging_config_broken_yaml"
  ];

  pythonImportsCheck = [ "privacyidea" ];

  postPatch = ''
    patchShebangs tests/testdata/scripts
    substituteInPlace privacyidea/lib/resolvers/LDAPIdResolver.py --replace \
      "/etc/privacyidea/ldap-ca.crt" \
      "${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  postInstall = ''
    rm -r $out/${python3'.sitePackages}/tests
  '';

  meta = with lib; {
    description = "Multi factor authentication system (2FA, MFA, OTP Server)";
    license = licenses.agpl3Plus;
    homepage = "http://www.privacyidea.org";
    maintainers = with maintainers; [ globin ma27 ];
  };
}
