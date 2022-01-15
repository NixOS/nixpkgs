{ lib, fetchFromGitHub, cacert, openssl, nixosTests
, python3
}:

let
  python3' = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.24";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "ebbb777cbf9312359b897bf81ba00dae0f5cb69fba2a18265dcc18a6f5ef7519";
        };
      });
      flask_migrate = super.flask_migrate.overridePythonAttrs (oldAttrs: rec {
        version = "2.7.0";
        src = python3.pkgs.fetchPypi {
          pname = "Flask-Migrate";
          inherit version;
          sha256 = "ae2f05671588762dd83a21d8b18c51fe355e86783e24594995ff8d7380dffe38";
        };
      });
      werkzeug = self.callPackage ../../../development/python-modules/werkzeug/1.nix { };
      flask = self.callPackage ../../../development/python-modules/flask/1.nix { };
      sqlsoup = super.sqlsoup.overrideAttrs ({ meta ? {}, ... }: {
        meta = meta // { broken = false; };
      });
      pyjwt = super.pyjwt.overridePythonAttrs (oldAttrs: rec {
        version = "1.7.1";
        src = python3.pkgs.fetchPypi {
          pname = "PyJWT";
          inherit version;
          sha256 = "sha256-jVmpdvt3Pz5qOchWNjV8Tw4kJwc5TK2t2YFPXLqiDpY=";
        };
        # requires different testing dependencies, and privacyIDEA will test this as well
        doCheck = false;
      });
    };
  };
in
python3'.pkgs.buildPythonPackage rec {
  pname = "privacyIDEA";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SsOEmbyEAKU3pdzsyqi5SwDgJMGEAzyCywoio9iFQAA=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = with python3'.pkgs; [
    cryptography pyrad pymysql python-dateutil flask-versioned flask_script
    defusedxml croniter flask_migrate pyjwt configobj sqlsoup pillow
    python-gnupg passlib pyopenssl beautifulsoup4 smpplib flask-babel
    ldap3 huey pyyaml qrcode oauth2client requests lxml cbor2 psycopg2
    pydash ecdsa google-auth importlib-metadata
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
