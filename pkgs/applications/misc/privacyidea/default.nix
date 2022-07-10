{ lib, fetchFromGitHub, cacert, openssl, nixosTests
, python39
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
        checkInputs = old.checkInputs ++ (with self; [
          requests
        ]);
        disabledTests = old.disabledTests ++ [
          # ResourceWarning: unclosed file
          "test_basic"
          "test_date_to_unix"
          "test_easteregg"
          "test_file_rfc2231_filename_continuations"
          "test_find_terminator"
          "test_save_to_pathlib_dst"
        ];
        disabledTestPaths = old.disabledTestPaths ++ [
          # ResourceWarning: unclosed file
          "tests/test_http.py"
        ];
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
    };
  };
in
python3'.pkgs.buildPythonPackage rec {
  pname = "privacyIDEA";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bjMw69nKecv87nwsLfb4+h677WjZlkVcIpVe53AI9WU=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = with python3'.pkgs; [
    cryptography pyrad pymysql python-dateutil flask-versioned flask_script
    defusedxml croniter flask_migrate pyjwt configobj sqlsoup pillow
    python-gnupg passlib pyopenssl beautifulsoup4 smpplib flask-babel
    ldap3 huey pyyaml qrcode oauth2client requests lxml cbor2 psycopg2
    pydash ecdsa google-auth importlib-metadata argon2-cffi bcrypt
  ];

  passthru.tests = { inherit (nixosTests) privacyidea; };

  checkInputs = with python3'.pkgs; [ openssl mock pytestCheckHook responses testfixtures ];
  disabledTests = [
    "AESHardwareSecurityModuleTestCase"
    "test_01_cert_request"
    "test_01_loading_scripts"
    "test_02_api_push_poll"
    "test_02_cert_enrolled"
    "test_02_enroll_rights"
    "test_02_get_resolvers"
    "test_02_success"
    "test_03_get_identifiers"
    "test_04_remote_user_auth"
    "test_14_convert_timestamp_to_utc"
  ];

  pythonImportsCheck = [ "privacyidea" ];

  postPatch = ''
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
