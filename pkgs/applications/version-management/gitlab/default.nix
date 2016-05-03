{ stdenv, lib, bundler, fetchFromGitHub, bundlerEnv, libiconv, ruby
, tzdata, git, nodejs, procps
}:

/* When updating the Gemfile add `gem "activerecord-nulldb-adapter"`
   to allow building the assets without a database */

let
  env = bundlerEnv {
    name = "gitlab";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    meta = with lib; {
      homepage = http://www.gitlab.com/;
      platforms = platforms.linux;
      maintainers = [ ];
      license = licenses.mit;
    };
  };

in

stdenv.mkDerivation rec {
  name = "gitlab-${version}";
  version = "8.5.12";

  buildInputs = [ ruby bundler tzdata git nodejs procps ];

  src = fetchFromGitHub {
    owner = "gitlabhq";
    repo = "gitlabhq";
    rev = "v${version}";
    sha256 = "144i97ywnr0xgm7gnwnwiy7kk5z1d71ccawl8qdhapz0705993l8";
  };

  patches = [
    ./remove-hardcoded-locations.patch
    ./disable-dump-schema-after-migration.patch
    ./nulladapter.patch
  ];

  postPatch = ''
    # For reasons I don't understand "bundle exec" ignores the
    # RAILS_ENV causing tests to be executed that fail because we're
    # not installing development and test gems above. Deleting the
    # tests works though.:
    rm lib/tasks/test.rake

    rm config/initializers/gitlab_shell_secret_token.rb

    substituteInPlace app/controllers/admin/background_jobs_controller.rb \
        --replace "ps -U" "${procps}/bin/ps -U"

    # required for some gems:
    cat > config/database.yml <<EOF
      production:
        adapter: <%= ENV["GITLAB_DATABASE_ADAPTER"] || sqlite %>
        database: gitlab
        host: <%= ENV["GITLAB_DATABASE_HOST"] || "127.0.0.1" %>
        password: <%= ENV["GITLAB_DATABASE_PASSWORD"] || "blerg" %>
        username: gitlab
        encoding: utf8
    EOF
  '';

  buildPhase = ''
    export GEM_HOME=${env}/${ruby.gemPath}
    mv config/gitlab.yml.example config/gitlab.yml
    GITLAB_DATABASE_ADAPTER=nulldb bundle exec rake assets:precompile RAILS_ENV=production
    mv config/gitlab.yml config/gitlab.yml.example
    mv config config.dist
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/gitlab
    ln -sf /run/gitlab/uploads $out/share/gitlab/public/uploads
    ln -sf /run/gitlab/config $out/share/gitlab/config
  '';

  passthru = {
    inherit env;
    inherit ruby;
  };
}
