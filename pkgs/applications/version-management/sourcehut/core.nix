{ stdenv, fetchgit, fetchNodeModules, buildPythonPackage
, pgpy, flask, bleach, misaka, humanize, markdown, psycopg2, pygments, requests
, sqlalchemy, flask_login, beautifulsoup4, sqlalchemy-utils, celery, alembic
, sassc, nodejs-11_x
, writeText }:

buildPythonPackage rec {
  pname = "srht";
  version = "0.52.13";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/core.sr.ht";
    rev = version;
    sha256 = "0i7gd2rkq4y4lffxsgb3mql9ddmk3vqckan29w266imrqs6p8c0z";
  };

  node_modules = fetchNodeModules {
    src = "${src}/srht";
    nodejs = nodejs-11_x;
    sha256 = "0axl50swhcw8llq8z2icwr4nkr5qsw2riih0a040f9wx4xiw4p6p";
  };

  patches = [
    ./disable-npm-install.patch
  ];

  nativeBuildInputs = [
    sassc
    nodejs-11_x
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

  # No actual? tests but seems like it needs this anyway
  preCheck = let
    config = writeText "config.ini" ''
      [webhooks]
      private-key=K6JupPpnr0HnBjelKTQUSm3Ro9SgzEA2T2Zv472OvzI=

      [meta.sr.ht]
      origin=http://meta.sr.ht.local
    '';
  in ''
    # Validation needs config option(s)
    # webhooks <- ( private-key )
    # meta.sr.ht <- ( origin )
    cp ${config} config.ini
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/srht;
    description = "Core modules for sr.ht";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
