{ stdenv, fetchgit, fetchurl, makeWrapper, bundlerEnv, bundler
, ruby, libxslt, libxml2, sqlite, openssl, docker
, dataDir ? "/var/lib/panamax-api" }@args:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "panamax-api-${version}";
  version = "0.2.16";

  env = bundlerEnv {
    name = "panamax-api-gems-${version}";
    inherit ruby;
    gemdir = ./.;
  };

  bundler = args.bundler.override { inherit ruby; };

  database_yml = builtins.toFile "database.yml" ''
    production:
      adapter: sqlite3
      database: <%= ENV["PANAMAX_DATABASE_PATH"] || "${dataDir}/db/mnt/db.sqlite3" %>
      timeout: 5000
  '';

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "git://github.com/CenturyLinkLabs/panamax-api";
    sha256 = "0dqg0fbmy5cgjh0ql8yqlybhjyyrslgghjrc24wjhd1rghjn2qi6";
  };

  buildInputs = [ makeWrapper sqlite openssl env.ruby bundler ];

  setSourceRoot = ''
    mkdir -p $out/share
    cp -R panamax-api $out/share/panamax-api
    export sourceRoot="$out/share/panamax-api"
  '';

  postPatch = ''
    find . -type f -exec sed -e 's|/usr/bin/docker|${docker}/bin/docker|g' -i "{}" \;
  '';

  configurePhase = ''
    export HOME=$PWD
    export GEM_HOME=${env}/${env.ruby.gemPath}
    export RAILS_ENV=production

    ln -sf ${database_yml} config/database.yml
  '';

  installPhase = ''
    rm -rf log tmp
    mv ./db ./_db
    ln -sf ${dataDir}/{db,state/log,state/tmp} .

    mkdir -p $out/bin
    makeWrapper bin/bundle "$out/bin/bundle" \
      --run "cd $out/share/panamax-api" \
      --prefix "PATH" : "$out/share/panamax-api/bin:${env.ruby}/bin:$PATH" \
      --prefix "HOME" : "$out/share/panamax-api" \
      --prefix "GEM_HOME" : "${env}/${env.ruby.gemPath}" \
      --prefix "GEM_PATH" : "$out/share/panamax-api:${bundler}/${env.ruby.gemPath}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/CenturyLinkLabs/panamax-api;
    description = "The API behind The Panamax UI";
    license = licenses.asl20;
    maintainers = with maintainers; [ matejc offline ];
    platforms = platforms.linux;
  };
}
