{
  lib,
  fetchFromSourcehut,
  buildPythonPackage,
  flask,
  humanize,
  sqlalchemy,
  sqlalchemy-utils,
  psycopg2,
  markdown,
  mistletoe,
  bleach,
  requests,
  beautifulsoup4,
  pygments,
  cryptography,
  prometheus-client,
  redis,
  celery,
  html5lib,
  tinycss2,
  sassc,
  pythonOlder,
  minify,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "srht";
  version = "0.83.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "core.sr.ht";
    rev = version;
    hash = "sha256-BGxELjXRkc4r6dZ/ayd4P7flGmdRiX3FNXgWw+C1EO0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedNativeBuildInputs = [
    sassc
    minify
  ];

  propagatedBuildInputs = [
    flask
    humanize
    sqlalchemy
    sqlalchemy-utils
    psycopg2
    markdown
    mistletoe
    bleach
    requests
    beautifulsoup4
    pygments
    cryptography
    prometheus-client
    redis
    celery
    # Used transitively through beautifulsoup4
    html5lib
    # Used transitively through bleach.css_sanitizer
    tinycss2
  ];

  env = {
    PREFIX = placeholder "out";
    PKGVER = version;
  };

  postInstall = ''
    make install
  '';

  pythonImportsCheck = [ "srht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/core.sr.ht";
    description = "Core modules for sr.ht";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
