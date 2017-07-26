{ stdenv, lib, bundler, fetchurl, fetchFromGitHub, bundlerEnv, libiconv, ruby
, tzdata, git, nodejs, procps, dpkg
}:

/* When updating the Gemfile add `gem "activerecord-nulldb-adapter"`
   to allow building the assets without a database */

let
  env = bundlerEnv {
    name = "gitlab";
    inherit ruby;
    gemdir = ./.;
    meta = with lib; {
      homepage = http://www.gitlab.com/;
      platforms = platforms.linux;
      maintainers = with maintainers; [ fpletz ];
      license = licenses.mit;
    };
  };

  version = "8.17.6";

  gitlabDeb = fetchurl {
    url = "https://packages.gitlab.com/gitlab/gitlab-ce/packages/debian/jessie/gitlab-ce_${version}-ce.0_amd64.deb/download";
    sha256 = "1pr8nfnkzmicn5nxjkq48l4nfjsp6v5j3v8p7cp8r86lgfdc6as3";
  };

in

stdenv.mkDerivation rec {
  name = "gitlab-${version}";

  buildInputs = [
    env ruby bundler tzdata git nodejs procps dpkg
  ];

  src = fetchFromGitHub {
    owner = "gitlabhq";
    repo = "gitlabhq";
    rev = "v${version}";
    sha256 = "1yyyn2j0a457q2xbcxz6b33r23myr8kxbm9whj2dwrrbp4p273hr";
  };

  patches = [
    ./remove-hardcoded-locations.patch
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
    mv config/gitlab.yml.example config/gitlab.yml

    dpkg -x ${gitlabDeb} .
    mv -v opt/gitlab/embedded/service/gitlab-rails/public/assets public
    rm -rf opt

    export GITLAB_DATABASE_ADAPTER=nulldb
    export SKIP_STORAGE_VALIDATION=true
    rake assets:precompile RAILS_ENV=production

    mv config/gitlab.yml config/gitlab.yml.example
    rm config/secrets.yml
    mv config config.dist
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/gitlab
    ln -sf /run/gitlab/uploads $out/share/gitlab/public/uploads
    ln -sf /run/gitlab/config $out/share/gitlab/config

    # rake tasks to mitigate CVE-2017-0882
    # see https://about.gitlab.com/2017/03/20/gitlab-8-dot-17-dot-4-security-release/
    cp ${./reset_token.rake} $out/share/gitlab/lib/tasks/reset_token.rake
  '';

  passthru = {
    inherit env;
    inherit ruby;
  };
}
