{ stdenv, fetchgit, fetchurl, makeWrapper
, ruby, rubygemsFun, openssl, sqlite, dataDir ? "/var/lib/panamax-ui"}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "panamax-ui-${version}";
  version = "0.2.11";

  bundler = fetchurl {
    url = "http://rubygems.org/downloads/bundler-1.7.9.gem";
    sha256 = "1gd201rh17xykab9pbqp0dkxfm7b9jri02llyvmrc0c5bz2vhycm";
  };

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "git://github.com/CenturyLinkLabs/panamax-ui";
    sha256 = "17j5ac8fzp377bzg7f239jdcc9j0c63bkx0ill5nl10i3h05z7jh";
  };

  gemspec = map (gem: fetchurl { url=gem.url; sha256=gem.hash; }) (import ./Gemfile-ui.nix);

  buildInputs = [ makeWrapper ruby openssl sqlite (rubygemsFun ruby) ];

  setSourceRoot = ''
    mkdir -p $out/share
    cp -R git-export $out/share/panamax-ui
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
    export GEM_HOME=$PWD

    mkdir -p vendor/cache
    ${concatStrings (map (gem: "ln -s ${gem} vendor/cache/${gem.name};") gemspec)}
    ln -s ${bundler} vendor/cache/${bundler.name}
  '';

  buildPhase = ''
    gem install --local vendor/cache/${bundler.name}
    bin/bundle install --verbose --local --without development test
    rm -f ./bin/*
    ruby ./gems/bundler-*/bin/bundle exec rake rails:update:bin
  '';

  installPhase = ''
    rm -rf log tmp db
    ln -sf ${dataDir}/{db,state/log,state/tmp} .

    mkdir -p $out/bin
    makeWrapper bin/bundle "$out/bin/bundle" \
      --run "cd $out/share/panamax-ui" \
      --prefix "PATH" : "$out/share/panamax-ui/bin:${ruby}/bin:$PATH" \
      --prefix "HOME" : "$out/share/panamax-ui" \
      --prefix "GEM_HOME" : "$out/share/panamax-ui" \
      --prefix "GEM_PATH" : "$out/share/panamax-ui"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/CenturyLinkLabs/panamax-ui;
    description = "The Web GUI for Panamax";
    license = licenses.asl20;
    maintainers = with maintainers; [ matejc offline ];
    platforms = platforms.linux;
  };
}
