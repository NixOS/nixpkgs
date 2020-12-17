{ stdenv, lib, python3, fetchPypi, appdirs, attrs, requests,
beautifulsoup4, click-plugins, elasticsearch, flask_login, flask_wtf,
pypandoc, python-dotenv, python-frontmatter, tinydb, validators,
watchdog, wtforms }:

python3.pkgs.buildPythonApplication rec {
  pname = "archivy";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6ff08a9ecd0a929663c36c73844ac5cb4dc847e69aae639a450c64d4320a506";
  };

  # Relax some dependencies
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'WTForms ==' 'WTForms >=' \
      --replace 'attrs == 20.2.0' 'attrs' \
      --replace 'beautifulsoup4 ==' 'beautifulsoup4 >=' \
      --replace 'elasticsearch ==' 'elasticsearch >=' \
      --replace 'python_dotenv ==' 'python_dotenv >=' \
      --replace 'python_frontmatter == 0.5.0' 'python_frontmatter' \
      --replace 'requests ==' 'requests >=' \
      --replace 'validators ==' 'validators >=' \
      --replace 'watchdog ==' 'watchdog >='
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
