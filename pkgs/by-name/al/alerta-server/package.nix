{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "alerta-server";
  version = "9.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alerta";
    repo = "alerta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w+DSMWrutn/8WOwIYtxFrIZ7VN5/w6jPPYhKMr+/rb4=";
  };

  build-system = [ python3.pkgs.setuptools_80 ];

  dependencies = with python3.pkgs; [
    bcrypt
    blinker
    cryptography
    defusedxml
    flask
    flask-compress
    flask-cors
    mohawk
    psycopg2
    pyjwt
    pymongo
    pyparsing
    python-dateutil
    pytz
    pyyaml
    requests
    requests-hawk
    sentry-sdk
    setuptools
    strenum
  ];

  # We can't run the tests from Nix, because they rely on the presence of a working MongoDB server
  doCheck = false;

  pythonImportsCheck = [
    "alerta"
  ];

  meta = {
    homepage = "https://alerta.io";
    description = "Monitoring System server";
    mainProgram = "alertad";
    changelog = "https://github.com/alerta/alerta/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
