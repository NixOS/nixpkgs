{ stdenv, fetchgit, fetchNodeModules, buildPythonPackage
, pgpy, flask, bleach, misaka, humanize, markdown, psycopg2, pygments, requests
, sqlalchemy, flask_login, beautifulsoup4, sqlalchemy-utils, celery, alembic
, sassc, nodejs
, writeText }:

buildPythonPackage rec {
  pname = "srht";
  version = "0.54.3";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/core.sr.ht";
    rev = version;
    sha256 = "1f4srhp5g6652anifs1vyijzi2v23l2rnfpf3x96j9r8rdap42rq";
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
    flask_login
    beautifulsoup4
    sqlalchemy-utils

    # Unofficial runtime dependencies?
    celery
    alembic
  ];

  PKGVER = version;

  preBuild = ''
    cp -r ${node_modules} srht/node_modules
  '';

  preCheck = let
    config = writeText "config.ini" ''
      [webhooks]
      private-key=K6JupPpnr0HnBjelKTQUSm3Ro9SgzEA2T2Zv472OvzI=

      [meta.sr.ht]
      origin=http://meta.sr.ht.local
    '';
  in ''
    cp -f ${config} config.ini
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/srht;
    description = "Core modules for sr.ht";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
