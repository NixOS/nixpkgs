{ python3
, fetchFromGitHub
, lib
}:

python3.pkgs.buildPythonPackage rec {
  pname = "giftless";
  version = "0.5.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "datopian";
    repo = "giftless";
    rev = "v${version}";
    sha256 = "sVVBtTTwhQ8i5x0sGXupul688eBiEz3YLmD8f3+/uqI=";
  };

  nativeBuildInputs = with python3.pkgs; [
    sphinx
    recommonmark
    furo
  ];

  buildInputs = with python3.pkgs; [
    figcan
    flask
    flask_marshmallow
    marshmallow-enum
    pyyaml
    pyjwt
    webargs
    python-dotenv
    typing-extensions
    flask-classful

    azure-storage-blob
    google-cloud-storage
    boto3
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-flake8
    pytest-isort
    pytest-mypy
    pytest-env
    pytest-cov
    pytest-vcr
  ];

  meta = with lib; {
    description = "Pluggable Git LFS server written";
    homepage = "https://github.com/datopian/giftless";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
