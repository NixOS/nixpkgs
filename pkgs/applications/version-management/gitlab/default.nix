{ stdenv, lib, fetchurl, fetchFromGitLab, bundlerEnv
, ruby, tzdata, git, procps, nettools
, gitlabEnterprise ? false
}:

let
  rubyEnv = bundlerEnv {
    name = "gitlab-env-${version}";
    inherit ruby;
    gemdir = ./rubyEnv- + "${if gitlabEnterprise then "ee" else "ce"}";
    groups = [ "default" "unicorn" "ed25519" "metrics" ];
  };

  flavour = if gitlabEnterprise then "ee" else "ce";
  data = (builtins.fromJSON (builtins.readFile ./data.json)).${flavour};

  version = data.version;
  sources = {
    gitlab = fetchFromGitLab {
      owner = data.owner;
      repo = data.repo;
      rev = data.rev;
      sha256 = data.repo_hash;
    };
    gitlabDeb = fetchurl {
      url = data.deb_url;
      sha256 = data.deb_hash;
    };
  };
in

stdenv.mkDerivation rec {
  name = "gitlab${if gitlabEnterprise then "-ee" else ""}-${version}";

  src = sources.gitlab;

  buildInputs = [
    rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler tzdata git procps nettools
  ];

  patches = [ ./remove-hardcoded-locations.patch ];

  postPatch = ''
    # For reasons I don't understand "bundle exec" ignores the
    # RAILS_ENV causing tests to be executed that fail because we're
    # not installing development and test gems above. Deleting the
    # tests works though.:
    rm lib/tasks/test.rake

    rm config/initializers/gitlab_shell_secret_token.rb

    substituteInPlace app/controllers/admin/background_jobs_controller.rb \
        --replace "ps -U" "${procps}/bin/ps -U"

    sed -i '/ask_to_continue/d' lib/tasks/gitlab/two_factor.rake
    sed -ri -e '/log_level/a config.logger = Logger.new(STDERR)' config/environments/production.rb
  '';

  buildPhase = ''
    mv config/gitlab.yml.example config/gitlab.yml

    # Building this requires yarn, node &c, so we just get it from the deb
    ar p ${sources.gitlabDeb} data.tar.gz | gunzip > gitlab-deb-data.tar
    # Work around unpacking deb containing binary with suid bit
    tar -f gitlab-deb-data.tar --delete ./opt/gitlab/embedded/bin/ksu
    tar -xf gitlab-deb-data.tar

    mv -v opt/gitlab/embedded/service/gitlab-rails/public/assets public
    rm -rf opt # only directory in data.tar.gz

    mv config/gitlab.yml config/gitlab.yml.example
    rm -f config/secrets.yml
    mv config config.dist
  '';

  installPhase = ''
    rm -r tmp
    mkdir -p $out/share
    cp -r . $out/share/gitlab
    rm -rf $out/share/gitlab/log
    ln -sf /run/gitlab/log $out/share/gitlab/log
    ln -sf /run/gitlab/uploads $out/share/gitlab/public/uploads
    ln -sf /run/gitlab/config $out/share/gitlab/config
    ln -sf /run/gitlab/tmp $out/share/gitlab/tmp

    # rake tasks to mitigate CVE-2017-0882
    # see https://about.gitlab.com/2017/03/20/gitlab-8-dot-17-dot-4-security-release/
    cp ${./reset_token.rake} $out/share/gitlab/lib/tasks/reset_token.rake
  '';

  passthru = {
    inherit rubyEnv;
    ruby = rubyEnv.wrappedRuby;
    GITALY_SERVER_VERSION = data.passthru.GITALY_SERVER_VERSION;
    GITLAB_PAGES_VERSION = data.passthru.GITLAB_PAGES_VERSION;
    GITLAB_SHELL_VERSION = data.passthru.GITLAB_SHELL_VERSION;
    GITLAB_WORKHORSE_VERSION = data.passthru.GITLAB_WORKHORSE_VERSION;
  };

  meta = with lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin krav ];
  } // (if gitlabEnterprise then
    {
      license = licenses.unfreeRedistributable; # https://gitlab.com/gitlab-org/gitlab-ee/raw/master/LICENSE
      description = "GitLab Enterprise Edition";
    }
  else
    {
      license = licenses.mit;
      description = "GitLab Community Edition";
      longDescription = "GitLab Community Edition (CE) is an open source end-to-end software development platform with built-in version control, issue tracking, code review, CI/CD, and more. Self-host GitLab CE on your own servers, in a container, or on a cloud provider.";
    });
}
