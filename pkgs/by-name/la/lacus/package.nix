{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lacus";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "lacus";
    rev = "refs/tags/v${version}";
    hash = "sha256-3sgTt3SsasltChCqHAWyujtUvoLwHWZzfWwlfnJA+zE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
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
