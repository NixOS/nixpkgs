{ stdenv, fetchgit, fetchurl, makeWrapper, bundlerEnv, bundler_HEAD
, ruby, rubygemsFun, openssl, sqlite, dataDir ? "/var/lib/panamax-ui"}:

with stdenv.lib;

let
  env = bundlerEnv {
    name = "panamax-api-gems";
    inherit ruby;
    gemset = ./gemset-ui.nix;
    gemfile = ./Gemfile-ui;
    lockfile = ./Gemfile-ui.lock;
  };
  bundler = bundler_HEAD.override { inherit ruby; };
in
stdenv.mkDerivation rec {
  name = "panamax-ui-${version}";
  version = "0.2.11";

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "git://github.com/CenturyLinkLabs/panamax-ui";
    sha256 = "17j5ac8fzp377bzg7f239jdcc9j0c63bkx0ill5nl10i3h05z7jh";
  };

  buildInputs = [ makeWrapper env.ruby openssl sqlite bundler ];

  setSourceRoot = ''
    mkdir -p $out/share
    cp -R panamax-ui $out/share/panamax-ui
    export sourceRoot="$out/share/panamax-ui"
  '';

  postPatch = ''
    find . -type f -iname "*.haml" -exec sed -e 's|CoreOS Journal|NixOS Journal|g' -i "{}" \;
    find . -type f -iname "*.haml" -exec sed -e 's|CoreOS Local|NixOS Local|g' -i "{}" \;
    find . -type f -iname "*.haml" -exec sed -e 's|CoreOS Host|NixOS Host|g' -i "{}" \;
    sed -e 's|CoreOS Local|NixOS Local|g' -i "spec/features/manage_application_spec.rb"
  '';

  configurePhase = ''
    export HOME=$PWD
    export GEM_HOME=${env}/${env.ruby.gemPath}
  '';

  buildPhase = ''
    rm -f ./bin/*
    bundle exec rake rails:update:bin
  '';

  installPhase = ''
    rm -rf log tmp db
    ln -sf ${dataDir}/{db,state/log,state/tmp} .

    mkdir -p $out/bin
    makeWrapper bin/bundle "$out/bin/bundle" \
      --run "cd $out/share/panamax-ui" \
      --prefix "PATH" : "$out/share/panamax-ui/bin:${env.ruby}/bin:$PATH" \
      --prefix "HOME" : "$out/share/panamax-ui" \
      --prefix "GEM_HOME" : "${env}/${env.ruby.gemPath}" \
      --prefix "GEM_PATH" : "$out/share/panamax-ui:${bundler}/${env.ruby.gemPath}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/CenturyLinkLabs/panamax-ui;
    description = "The Web GUI for Panamax";
    license = licenses.asl20;
    maintainers = with maintainers; [ matejc offline ];
    platforms = platforms.linux;
  };
}
