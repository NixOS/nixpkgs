{ stdenv, fetchgit, fetchNodeModules, buildPythonPackage
, pgpy, flask, bleach, misaka, humanize, html5lib, markdown, psycopg2, pygments
, requests, sqlalchemy, cryptography, beautifulsoup4, sqlalchemy-utils, prometheus_client
, celery, alembic, importlib-metadata
, sassc, nodejs
, writeText }:

buildPythonPackage rec {
  pname = "srht";
  version = "0.59.13";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/core.sr.ht";
    rev = version;
    sha256 = "1rgndpr0w25mxg0d8x54lay82d0p01aygallsgr1lw5zs4r3ldz6";
  };

  node_modules = fetchNodeModules {
    src = "${src}/srht";
    nodejs = nodejs;
    sha256 = "0gwa2xb75g7fclrsr7r131kj8ri5gmhd96yw1iws5pmgsn2rlqi1";
  };

  patches = [
    ./disable-npm-install.patch
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
    sqlalchemy
    cryptography
    beautifulsoup4
    sqlalchemy-utils
    prometheus_client

    # Unofficial runtime dependencies?
    celery
    alembic
    importlib-metadata
  ];

  PKGVER = version;

  preBuild = ''
    cp -r ${node_modules} srht/node_modules
  '';

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/srht";
    description = "Core modules for sr.ht";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
