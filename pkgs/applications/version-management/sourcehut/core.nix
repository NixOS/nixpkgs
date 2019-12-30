{ stdenv, fetchgit, fetchNodeModules, buildPythonPackage
, pgpy, flask, bleach, misaka, humanize, markdown, psycopg2, pygments, requests
, sqlalchemy, cryptography, beautifulsoup4, sqlalchemy-utils, celery, alembic
, importlib-metadata
, sassc, nodejs
, writeText }:

buildPythonPackage rec {
  pname = "srht";
  version = "0.57.2";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/core.sr.ht";
    rev = version;
    sha256 = "11rfpb0wf1xzrhcnpahaghmi5626snzph0vsbxlmmqx75wf0p6mf";
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
    markdown
    psycopg2
    pygments
    requests
    sqlalchemy
    cryptography
    beautifulsoup4
    sqlalchemy-utils

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
    homepage = https://git.sr.ht/~sircmpwn/srht;
    description = "Core modules for sr.ht";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
