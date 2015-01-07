{ stdenv, buildEnv, fetchgit, fetchurl, makeWrapper
, ruby, rubygemsFun, libxslt, libxml2, sqlite, openssl, cacert, docker
, dataDir ? "/var/lib/panamax-api" }:

with stdenv.lib;

let
  database_yml = builtins.toFile "database.yml" ''
    production:
      adapter: sqlite3
      database: <%= ENV["PANAMAX_DATABASE_PATH"] || "${dataDir}/db/mnt/db.sqlite3" %>
      timeout: 5000
  '';

in stdenv.mkDerivation rec {
  name = "panamax-api-${version}";
  version = "0.2.11";

  bundler = fetchurl {
    url = "http://rubygems.org/downloads/bundler-1.7.9.gem";
    sha256 = "1gd201rh17xykab9pbqp0dkxfm7b9jri02llyvmrc0c5bz2vhycm";
  };

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "git://github.com/CenturyLinkLabs/panamax-api";
    sha256 = "01sz7jibn1rqfga85pr4p8wk6jfldzfaxj1726vs6znmcwhfkcgj";
  };

  gemspec = map (gem: fetchurl { url=gem.url; sha256=gem.hash; }) (import ./Gemfile-api.nix);

  buildInputs = [ makeWrapper sqlite openssl ruby (rubygemsFun ruby) ];

  setSourceRoot = ''
    mkdir -p $out/share
    cp -R git-export $out/share/panamax-api
    export sourceRoot="$out/share/panamax-api"
  '';

  postPatch = ''
    find . -type f -exec sed -e 's|/usr/bin/docker|${docker}/bin/docker|g' -i "{}" \;
  '';

  configurePhase = ''
    export HOME=$PWD
    export GEM_HOME=$PWD
    export RAILS_ENV=production

    mkdir -p vendor/cache
    ${concatStrings (map (gem: "ln -s ${gem} vendor/cache/${gem.name};") gemspec)}
    ln -s ${bundler} vendor/cache/${bundler.name}
    ln -sf ${database_yml} config/database.yml
  '';

  buildPhase = ''
    gem install --local vendor/cache/${bundler.name}
    bin/bundle install -j4 --verbose --local --deployment --without development test
  '';

  installPhase = ''
    rm -rf log tmp
    mv ./db ./_db
    ln -sf ${dataDir}/{db,state/log,state/tmp} .

    mkdir -p $out/bin
    makeWrapper bin/bundle "$out/bin/bundle" \
      --run "cd $out/share/panamax-api" \
      --prefix "PATH" : "$out/share/panamax-api/bin:${ruby}/bin:$PATH" \
      --prefix "HOME" : "$out/share/panamax-api" \
      --prefix "GEM_HOME" : "$out/share/panamax-api" \
      --prefix "OPENSSL_X509_CERT_FILE" : "${cacert}/etc/ca-bundle.crt" \
      --prefix "SSL_CERT_FILE" : "${cacert}/etc/ca-bundle.crt"
  '';

  postFixup = ''
    rm -r vendor/cache/*
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/CenturyLinkLabs/panamax-api;
    description = "The API behind The Panamax UI";
    license = licenses.asl20;
    maintainers = with maintainers; [ matejc offline ];
    platforms = platforms.linux;
  };
}
