{ stdenv, fetchgit, fetchNodeModules, buildPythonPackage
, pgpy, flask, bleach, misaka, humanize, markdown, psycopg2, pygments, requests
, sqlalchemy, cryptography, beautifulsoup4, sqlalchemy-utils, celery, alembic
, importlib-metadata
, sassc, nodejs
, writeText }:

buildPythonPackage rec {
  pname = "srht";
  version = "0.54.4";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/core.sr.ht";
    rev = version;
    sha256 = "0flxvn178hqd8ljz89ddis80zfnmzgimv4506w4dg2flbwzywy7z";
  };

  node_modules = fetchNodeModules {
    src = "${src}/srht";
    nodejs = nodejs;
    sha256 = "0axl50swhcw8llq8z2icwr4nkr5qsw2riih0a040f9wx4xiw4p6p";
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
