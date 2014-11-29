{ stdenv, fetchurl, ruby, rubyLibs, libiconv, libxslt, libxml2, pkgconfig, libffi, postgresql, libyaml, ncurses, curl, openssh, redis, zlib, icu, checkinstall, logrotate, docutils, cmake, git, gdbm, readline, unzip, gnumake, which, tzdata }:

let
  gemspec = map (gem: fetchurl { url=gem.url; sha256=gem.hash; }) (import ./Gemfile.nix);


in stdenv.mkDerivation rec {
  version = "7.4.2";
  name = "gitlab-${version}";

  src = fetchurl {
    url = "https://github.com/gitlabhq/gitlabhq/archive/v${version}.zip";
    sha256 = "01iplkpa4scr0wcap6vjrc960dj15z4ciclaqswj0sz5hrp9glw6";
  };

  buildInputs = [
    ruby rubyLibs.bundler libyaml gdbm readline ncurses curl openssh redis zlib
    postgresql libxslt libxml2 pkgconfig libffi icu checkinstall logrotate docutils
    git unzip gnumake which cmake
  ];

  # cmake is required by a build depdenceny, not the main binary:
  dontUseCmakeConfigure = true;

  patches = [
    ./remove-hardcoded-locations.patch
  ];
  postPatch = ''
    mv config/gitlab.yml.example config/gitlab.yml
  '';

  installPhase = ''
    mkdir -p $out/share/gitlab
    cp -R . $out/share/gitlab
    cd $out/share/gitlab

    export HOME=$(pwd)
    export GITLAB_EMAIL_FROM="required@to-make-it-work.org"

    # required for some gems:
    cat > config/database.yml <<EOF
      production:
        adapter: postgresql
        database: gitlab
        host: <%= ENV["GITLAB_DATABASE_HOST"] || "127.0.0.1" %>
        password: <%= ENV["GITLAB_DATABASE_PASSWORD"] || "blerg" %>
        username: gitlab
        encoding: utf8
    EOF

    mkdir -p vendor/cache
    ${stdenv.lib.concatStrings (map (gem: "ln -s ${gem} vendor/cache/${gem.name};") gemspec)}

    bundle config build.nokogiri \
      --use-system-libraries \
      --with-xslt-dir=${libxslt} \
      --with-xml2-dir=${libxml2} \
      --with-pkg-config=${pkgconfig}/bin/pkg-config \
      --with-pg-config=${postgresql}/bin/pg_config

    # See https://github.com/gitlabhq/gitlab-public-wiki/wiki/Trouble-Shooting-Guide:
    bundle install -j4 --verbose --local --deployment --without development test mysql

    # Fix timezone data directory
    substituteInPlace $out/share/gitlab/vendor/bundle/ruby/*/gems/tzinfo-*/lib/tzinfo/zoneinfo_data_source.rb \
      --replace "/etc/zoneinfo" "${tzdata}/share/zoneinfo"

    # For reasons I don't understand "bundle exec" ignores the
    # RAILS_ENV causing tests to be executed that fail because we're
    # not installing development and test gems above. Deleting the
    # tests works though.:
    rm $out/share/gitlab/lib/tasks/test.rake

    # Assets
    bundle exec rake assets:precompile RAILS_ENV=production
  '';

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.mit;
  };
}
