{ lib
, fetchFromSourcehut
, buildPythonPackage
, flask
, humanize
, sqlalchemy
, sqlalchemy-utils
, psycopg2
, markdown
, mistletoe
, bleach
, requests
, beautifulsoup4
, pygments
, cryptography
, prometheus-client
, alembic
, redis
, celery
, html5lib
, importlib-metadata
, tinycss2
, sassc
, pythonOlder
, minify
, setuptools
}:

buildPythonPackage rec {
  pname = "srht";
  version = "0.69.15";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "core.sr.ht";
    rev = version;
    sha256 = "sha256-T9yewweqnWL3IW5PHGyAcsIWCGn1ayK2rwrHVukYpgE=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix Unix socket support in RedisQueueCollector
    patches/redis-socket/core/0001-Fix-Unix-socket-support-in-RedisQueueCollector.patch
  ];

  nativeBuildInputs = [
    setuptools
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
    alembic
    redis
    celery
    # Used transitively through beautifulsoup4
    html5lib
    # Used transitively trough bleach.css_sanitizer
    tinycss2
    # Used by srht.debug
    importlib-metadata
  ];

  PKGVER = version;

  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "srht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/srht";
    description = "Core modules for sr.ht";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
