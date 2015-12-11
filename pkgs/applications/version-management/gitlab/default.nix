{ stdenv, lib, bundler, fetchgit, bundlerEnv, defaultGemConfig, libiconv, ruby
, tzdata, git, nodejs, procps
}:

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
  version = "8.0.5";
  buildInputs = [ ruby bundler tzdata git nodejs procps ];
  src = fetchgit {
    url = "https://github.com/gitlabhq/gitlabhq.git";
    rev = "2866c501b5a5abb69d101cc07261a1d684b4bd4c";
    fetchSubmodules = false;
    sha256 = "edc6bedd5e79940189355d8cb343d20b0781b69fcef56ccae5906fa5e81ed521";
  };

  patches = [
    ./remove-hardcoded-locations.patch
    ./disable-dump-schema-after-migration.patch
  ];
  postPatch = ''
    # For reasons I don't understand "bundle exec" ignores the
    # RAILS_ENV causing tests to be executed that fail because we're
    # not installing development and test gems above. Deleting the
    # tests works though.:
    rm lib/tasks/test.rake

    mv config/gitlab.yml.example config/gitlab.yml
    rm config/initializers/gitlab_shell_secret_token.rb

    substituteInPlace app/controllers/admin/background_jobs_controller.rb \
        --replace "ps -U" "${procps}/bin/ps -U"

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
  '';
  buildPhase = ''
    export GEM_HOME=${env}/${ruby.gemPath}
    bundle exec rake assets:precompile RAILS_ENV=production
  '';
  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/gitlab
  '';
  passthru = {
    inherit env;
    inherit ruby;
  };
}
