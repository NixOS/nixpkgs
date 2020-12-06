{ stdenv, lib, python3, fetchPypi, appdirs, attrs, requests,
beautifulsoup4, click-plugins, elasticsearch, flask_login, flask_wtf,
pypandoc, python-dotenv, python-frontmatter, tinydb, validators,
watchdog, wtforms }:

python3.pkgs.buildPythonApplication rec {
  pname = "archivy";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cb760da57dc9dcdd62c0af824993d1715ec7035915629b4046d8bf50442756c";
  };

  # Relax some dependencies
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'validators ==' 'validators >=' \
      --replace 'elasticsearch ==' 'elasticsearch >=' \
      --replace 'python-dotenv ==' 'python-dotenv >=' \
      --replace 'beautifulsoup4 ==' 'beautifulsoup4 >=' \
      --replace 'WTForms ==' 'WTForms >=' \
      --replace 'python_dotenv ==' 'python_dotenv >=' \
      --replace 'attrs == 20.2.0' 'attrs' \
      --replace 'python_frontmatter == 0.5.0' 'python_frontmatter' \
      --replace 'requests ==' 'requests >='
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
  ];

  # __init__.py attempts to mkdir in read-only file system
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Self-hosted knowledge repository";
    homepage = "https://archivy.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
