{ lib
, fetchFromSourcehut
, fetchNodeModules
, buildPythonPackage
, pgpy
, flask
, bleach
, misaka
, humanize
, html5lib
, markdown
, psycopg2
, pygments
, requests
, sqlalchemy
, cryptography
, beautifulsoup4
, sqlalchemy-utils
, prometheus-client
, celery
, alembic
, importlib-metadata
, mistletoe
, minio
, sassc
, nodejs
, redis
}:

buildPythonPackage rec {
  pname = "srht";
  version = "0.69.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "core.sr.ht";
    rev = version;
    sha256 = "sha256-s/I0wxtPggjTkkTZnhm77PxdQjiT0Vq2MIk7JMvdupc=";
    fetchSubmodules = true;
  };

  node_modules = fetchNodeModules {
    src = "${src}/srht";
    nodejs = nodejs;
    sha256 = "sha256-IWKahdWv3qJ5DNyb1GB9JWYkZxghn6wzZe68clYXij8=";
  };

  patches = [
    # Disable check for npm
    ./disable-npm-install.patch
    # Fix Unix socket support in RedisQueueCollector
    patches/redis-socket/core/0001-Fix-Unix-socket-support-in-RedisQueueCollector.patch
  ];

  nativeBuildInputs = [
    sassc
    nodejs
  ];

  propagatedBuildInputs = [
    pgpy
    flask
    bleach
    misaka
    humanize
    html5lib
    markdown
    psycopg2
    pygments
    requests
    mistletoe
    sqlalchemy
    cryptography
    beautifulsoup4
    sqlalchemy-utils
    prometheus-client

    # Unofficial runtime dependencies?
    celery
    alembic
    importlib-metadata
    minio
    redis
  ];

  PKGVER = version;

  preBuild = ''
    cp -r ${node_modules} srht/node_modules
  '';

  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "srht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/srht";
    description = "Core modules for sr.ht";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
