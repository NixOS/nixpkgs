{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "semiphemeral";
  version = "0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KRi3zfRWGRZJjQ6KPqBI9wQ6yU8Ohx0TDtA5qoak35U=";
  };

  doCheck = false; # upstream has no tests

  pythonImportsCheck = [ "semiphemeral" ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    sqlalchemy
    flask
    tweepy
    colorama
  ];

  meta = with lib; {
    description = "Automatically delete your old tweets, except for the ones you want to keep";
    homepage = "https://github.com/micahflee/semiphemeral";
    license = licenses.mit;
    maintainers = with maintainers; [ amanjeev ];
    mainProgram = "semiphemeral";
  };
}
