{ lib, fetchFromGitHub, cacert, openssl, nixosTests
, python39, fetchpatch
}:

let
  python3' = python39.override {
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
    };
  };
in
python3'.pkgs.buildPythonPackage rec {
  pname = "privacyIDEA";
  version = "3.7.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QoVL6WJjX6+sN5S/iqV3kcfQ5fWTXkTnf6NpZcw3bGo=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = with python3'.pkgs; [
    cryptography pyrad pymysql python-dateutil flask-versioned flask_script
    defusedxml croniter flask_migrate pyjwt configobj sqlsoup pillow
    python-gnupg passlib pyopenssl beautifulsoup4 smpplib flask-babel
    ldap3 huey pyyaml qrcode oauth2client requests lxml cbor2 psycopg2
    pydash ecdsa google-auth importlib-metadata argon2-cffi bcrypt
  ];

  patches = [
    # Apply https://github.com/privacyidea/privacyidea/pull/3304, fixes
    # `Exceeds the limit (4300) for integer string conversion` in the tests,
    # see https://hydra.nixos.org/build/192932057
    (fetchpatch {
      url = "https://github.com/privacyidea/privacyidea/commit/0e28f36c0b3291a361669f4a3a77c294f4564475.patch";
      sha256 = "sha256-QqcO8bkt+I2JKce/xk2ZhzEaLZ3E4uZ4x5W9Kk0pMQQ=";
    })
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
