{ stdenv, fetchurl, ruby, bundler, libiconv, libxslt, libxml2, pkgconfig, libffi, glibc, imagemagickBig, postgresql }:

let
  gemspec = map (gem: fetchurl { url=gem.url; sha256=gem.hash; }) (import ./Gemfile.nix);
in stdenv.mkDerivation rec {
  version = "2.5.2";
  name = "redmine-${version}";

  src = fetchurl {
    url = "http://www.redmine.org/releases/${name}.tar.gz";
    sha256 = "0x0zwxyj4dwbk7l64s3lgny10mjf0ba8jwrbafsm4d72sncmacv0";
  };

  hardeningDisable = [ "format" ];

  # taken from redmine (2.5.1-2~bpo70+3) in debian wheezy-backports
  # needed to separate run-time and build-time directories
  patches = [
    ./2002_FHS_through_env_vars.patch
    ./2004_FHS_plugins_assets.patch
    ./2003_externalize_session_config.patch
  ];

  postPatch = ''
    substituteInPlace lib/redmine/plugin.rb --replace "File.join(Rails.root, 'plugins')" "ENV['RAILS_PLUGINS']"
    substituteInPlace lib/redmine/plugin.rb --replace "File.join(Rails.root, 'plugins', id.to_s, 'db', 'migrate')" "File.join(ENV['RAILS_PLUGINS'], id.to_s, 'db', 'migrate')"
    substituteInPlace config/routes.rb --replace '"plugins/*", Rails.root' 'ENV["RAILS_PLUGINS"] + "/*"'
  '';

  buildInputs = [
    ruby bundler libiconv
    libxslt libxml2 pkgconfig libffi
    imagemagickBig postgresql
  ];

  installPhase = ''
    mkdir -p $out/share/redmine/
    cp -R . $out/share/redmine/
    cd $out/share/redmine
    ln -s ${./Gemfile.lock} Gemfile.lock
    export HOME=$(pwd)

    cat > config/database.yml <<EOF
      production:
        adapter: postgresql
    EOF

    mkdir -p vendor/cache
    ${stdenv.lib.concatStrings (map (gem: "ln -s ${gem} vendor/cache/${gem.name};") gemspec)}

    bundle config build.nokogiri --use-system-libraries --with-iconv-dir="${libiconv}" --with-xslt-dir="${libxslt.dev}" --with-xml2-dir="${libxml2.dev}"

    bundle install --verbose --local --deployment

    # make sure we always load pg package
    echo "gem \"pg\"" >> Gemfile

    # make rails server happy
    mkdir -p tmp/pids

    # cleanup
    rm config/database.yml
  '';

  meta = with stdenv.lib; {
    homepage = http://www.redmine.org/;
    platforms = platforms.linux;
    maintainers = [ maintainers.garbas ];
    license = licenses.gpl2;
  };
}
