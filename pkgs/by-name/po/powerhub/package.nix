{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "powerhub";
  version = "2.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AdrianVollmer";
    repo = "PowerHub";
    tag = version;
    hash = "sha256-vZIdYjP7F7lUauOCkouwUpR/gO0gEjFR8HLqD3ZjS3E=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cheroot
    cryptography
    dnspython
    flask
    flask-socketio
    flask-sqlalchemy
    importlib-metadata
    jinja2
    pyopenssl
    python-magic
    python-socketio
    requests
    service-identity
    simple-websocket
    sqlalchemy
    twisted
    watchdog
    werkzeug
    wsgidav
  ];

  # Tests uses XDG
  doCheck = false;

  pythonImportsCheck = [
    "powerhub"
  ];

  preCheck = ''
    cd tests/helpers
  '';

  meta = {
    description = "Post exploitation tool based on a web application, focusing on bypassing endpoint protection and application whitelisting";
    homepage = "https://github.com/AdrianVollmer/PowerHub";
    changelog = "https://github.com/AdrianVollmer/PowerHub/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "powerhub";
  };
}
