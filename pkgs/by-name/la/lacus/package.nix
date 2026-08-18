{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "lacus";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "lacus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fk6NfBdUGGyOhVOJcGCRNldcw4JRHFr7p+tFuccYp7Y=";
  };

  pythonRelaxDeps = [
    "gunicorn"
    "psutil"
    "redis"
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    flask-restx
    gunicorn
    lacuscore
    psutil
    redis
    rich
    werkzeug
  ];

  meta = {
    description = "Capturing system using playwright";
    homepage = "https://github.com/ail-project/lacus";
    changelog = "https://github.com/ail-project/lacus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
