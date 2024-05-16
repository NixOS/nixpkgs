{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lacus";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "lacus";
    rev = "refs/tags/v${version}";
    hash = "sha256-VFNW13PupJOroIhqnuLOq3mqU9nXEy1hmjHBQfErSN8=";
  };

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

  meta = with lib; {
    description = "Capturing system using playwright";
    homepage = "https://github.com/ail-project/lacus";
    changelog = "https://github.com/ail-project/lacus/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
