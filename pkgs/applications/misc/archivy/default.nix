{ lib
, buildPythonApplication
, fetchPypi
, appdirs
, attrs
, beautifulsoup4
, click-plugins
, elasticsearch
, flask-compress
, flask_login
, flask_wtf
, html2text
, python-dotenv
, python-frontmatter
, requests
, tinydb
, validators
, werkzeug
, wtforms
}:

buildPythonApplication rec {
  pname = "archivy";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oSmwQcKvp9RABmc7aq6fdLOZapMauIi6+7azVTXVb30=";
  };

  # Relax some dependencies
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'WTForms ==' 'WTForms >=' \
      --replace 'attrs == 20.2.0' 'attrs' \
      --replace 'elasticsearch ==' 'elasticsearch >=' \
      --replace 'python_dotenv ==' 'python_dotenv >=' \
      --replace 'python_frontmatter == 0.5.0' 'python_frontmatter' \
      --replace 'requests ==' 'requests >=' \
      --replace 'validators ==' 'validators >=' \
      --replace 'tinydb ==' 'tinydb >='
  '';

  propagatedBuildInputs = [
    appdirs
    attrs
    beautifulsoup4
    click-plugins
    elasticsearch
    flask-compress
    flask_login
    flask_wtf
    html2text
    python-dotenv
    python-frontmatter
    requests
    tinydb
    validators
    werkzeug
    wtforms
  ];

  # __init__.py attempts to mkdir in read-only file system
  doCheck = false;

  meta = with lib; {
    description = "Self-hosted knowledge repository";
    homepage = "https://archivy.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
