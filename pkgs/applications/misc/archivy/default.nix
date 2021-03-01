{ lib, python3, fetchPypi, appdirs, attrs, requests,
beautifulsoup4, click-plugins, elasticsearch, flask_login, flask_wtf,
pypandoc, python-dotenv, python-frontmatter, tinydb, validators,
watchdog, wtforms, html2text, flask-compress }:

python3.pkgs.buildPythonApplication rec {
  pname = "archivy";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53a43e26e9081ac266412d8643c66c07c289c4639bbaec374fd5147441253a4f";
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
  '';

  propagatedBuildInputs = [
    appdirs
    attrs
    beautifulsoup4
    click-plugins
    elasticsearch
    flask_login
    flask_wtf
    pypandoc
    python-dotenv
    python-frontmatter
    tinydb
    requests
    validators
    watchdog
    wtforms
    html2text
    flask-compress
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
