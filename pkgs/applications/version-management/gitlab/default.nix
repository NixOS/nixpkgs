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

  version = "11.4.3";

  sources = if gitlabEnterprise then {
    gitlabDeb = fetchurl {
      url = "https://packages.gitlab.com/gitlab/gitlab-ee/packages/debian/stretch/gitlab-ee_${version}-ee.0_amd64.deb/download.deb";
      sha256 = "1cw75qj508z6n00rqgqjzdm2013kyb7c57cypmq0m08nc6f3jspz";
    };
    gitlab = fetchFromGitLab {
      owner = "gitlab-org";
      repo = "gitlab-ee";
      rev = "v${version}-ee";
      sha256 = "1vqc77whpbsifbm9vgcmpxnw13v8jz1s9q04i8jfv99c59fjlids";
    };
  } else {
    gitlabDeb = fetchurl {
      url = "https://packages.gitlab.com/gitlab/gitlab-ce/packages/debian/stretch/gitlab-ce_${version}-ce.0_amd64.deb/download.deb";
      sha256 = "0vk03k42pp92h520wnynl9czcigjhj9m7y68z1x0gwqr9m61r7zm";
    };
    gitlab = fetchFromGitLab {
      owner = "gitlab-org";
      repo = "gitlab-ce";
      rev = "v${version}";
      sha256 = "1zvjz2gv2vwqqjz52zcvi0ap3d8rdbpgsqk9wv80hqq4v37a5gfx";
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
