{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flit-core,

  # extras: babel
  babel,
  flask-babel,

  # extras: common
  argon2-cffi,
  bcrypt,
  bleach,
  flask-mailman,

  # extras: fsqla
  flask-sqlalchemy,
  sqlalchemy,
  sqlalchemy-utils,

  # extras: mfa
  cryptography,
  phonenumberslite,
  webauthn,
  qrcode,

  # propagates
  email-validator,
  flask,
  flask-login,
  flask-principal,
  flask-wtf,
  markupsafe,
  passlib,
  importlib-resources,
  wtforms,

  # tests
  authlib,
  flask-sqlalchemy-lite,
  freezegun,
  mongoengine,
  mongomock,
  peewee,
  pony,
  pytestCheckHook,
  requests,
  zxcvbn,
}:

buildPythonPackage rec {
  pname = "flask-security";
  version = "5.6.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-security";
    tag = version;
    hash = "sha256-sAO8wQd/YgPbi5+nQmkmmcTg7DJPYdUoT/EOMUpzr/M=";
  };

  build-system = [ flit-core ];

  dependencies = [
    email-validator
    flask
    flask-login
    flask-principal
    flask-wtf
    markupsafe
    passlib
    importlib-resources
    wtforms
  ];

  optional-dependencies = {
    babel = [
      babel
      flask-babel
    ];
    common = [
      argon2-cffi
      bcrypt
      bleach
      flask-mailman
    ];
    fsqla = [
      flask-sqlalchemy
      sqlalchemy
      sqlalchemy-utils
    ];
    mfa = [
      cryptography
      phonenumberslite
      webauthn
      qrcode
    ];
  };

  nativeCheckInputs =
    [
      authlib
      flask-sqlalchemy-lite
      freezegun
      mongoengine
      mongomock
      peewee
      pony
      pytestCheckHook
      requests
      zxcvbn
    ]
    ++ optional-dependencies.babel
    ++ optional-dependencies.common
    ++ optional-dependencies.fsqla
    ++ optional-dependencies.mfa;

  preCheck = ''
    pybabel compile --domain flask_security -d flask_security/translations
  '';

  disabledTests = [
    # needs /etc/resolv.conf
    "test_login_email_whatever"
  ];

  pythonImportsCheck = [ "flask_security" ];

  meta = with lib; {
    changelog = "https://github.com/pallets-eco/flask-security/blob/${version}/CHANGES.rst";
    homepage = "https://github.com/pallets-eco/flask-security";
    description = "Quickly add security features to your Flask application";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
