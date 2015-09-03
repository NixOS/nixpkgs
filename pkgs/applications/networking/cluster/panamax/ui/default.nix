{ stdenv, fetchgit, fetchurl, makeWrapper, bundlerEnv, bundler_HEAD
, ruby, rubygemsFun, openssl, sqlite, dataDir ? "/var/lib/panamax-ui"}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "panamax-ui-${version}";
  version = "0.2.14";

  env = bundlerEnv {
    name = "panamax-ui-gems-${version}";
    inherit ruby;
    gemset = ./gemset.nix;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    buildInputs = [ openssl ];
  };

  bundler = bundler_HEAD.override { inherit ruby; };

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "git://github.com/CenturyLinkLabs/panamax-ui";
    sha256 = "0vwy0gazfx3zkf2bx862jspidgn5p97d3jaq99x38qfhxp554sn9";
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
    # fix libv8 dependency
    substituteInPlace Gemfile.lock --replace "3.16.14.7" "3.16.14.11"
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
