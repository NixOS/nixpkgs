{ stdenv, lib, fetchurl, fetchpatch, fetchFromGitLab, bundlerEnv
, ruby, tzdata, git, nettools, nixosTests, nodejs, openssl
, gitlabEnterprise ? false, callPackage, yarn
, fixup_yarn_lock, replace, file
}:

let
  data = (builtins.fromJSON (builtins.readFile ./data.json));

  version = data.version;
  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  rubyEnv = bundlerEnv rec {
    name = "gitlab-env-${version}";
    inherit ruby;
    gemdir = ./rubyEnv;
    gemset =
      let x = import (gemdir + "/gemset.nix");
      in x // {
        # grpc expects the AR environment variable to contain `ar rpc`. See the
        # discussion in nixpkgs #63056.
        grpc = x.grpc // {
          patches = [ ./fix-grpc-ar.patch ];
          dontBuild = false;
        };
        # the openssl needs the openssl include files
        openssl = x.openssl // {
          buildInputs = [ openssl ];
        };
        ruby-magic = x.ruby-magic // {
          buildInputs = [ file ];
          buildFlags = [ "--enable-system-libraries" ];
        };
      };
    groups = [
      "default" "unicorn" "ed25519" "metrics" "development" "puma" "test" "kerberos"
    ];
    # N.B. omniauth_oauth2_generic and apollo_upload_server both provide a
    # `console` executable.
    ignoreCollisions = true;
  };

  yarnOfflineCache = (callPackage ./yarnPkgs.nix {}).offline_cache;

  assets = stdenv.mkDerivation {
    pname = "gitlab-assets";
    inherit version src;

    nativeBuildInputs = [ rubyEnv.wrappedRuby rubyEnv.bundler nodejs yarn git ];

    # Since version 12.6.0, the rake tasks need the location of git,
    # so we have to apply the location patches here too.
    patches = [ ./remove-hardcoded-locations.patch ];
    # One of the patches uses this variable - if it's unset, execution
    # of rake tasks fails.
    GITLAB_LOG_PATH = "log";
    FOSS_ONLY = !gitlabEnterprise;

    configurePhase = ''
      runHook preConfigure

      # Some rake tasks try to run yarn automatically, which won't work
      rm lib/tasks/yarn.rake

      # The rake tasks won't run without a basic configuration in place
      mv config/database.yml.env config/database.yml
      mv config/gitlab.yml.example config/gitlab.yml

      # Yarn and bundler wants a real home directory to write cache, config, etc to
      export HOME=$NIX_BUILD_TOP/fake_home

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock

      # fixup_yarn_lock currently doesn't correctly fix the dagre-d3
      # url, so we have to do it manually
      ${replace}/bin/replace-literal -f -e '"https://codeload.github.com/dagrejs/dagre-d3/tar.gz/e1a00e5cb518f5d2304a35647e024f31d178e55b"' \
                                           '"https___codeload.github.com_dagrejs_dagre_d3_tar.gz_e1a00e5cb518f5d2304a35647e024f31d178e55b"' yarn.lock

      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive

      patchShebangs node_modules/

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      bundle exec rake gettext:po_to_json RAILS_ENV=production NODE_ENV=production
      bundle exec rake rake:assets:precompile RAILS_ENV=production NODE_ENV=production
      bundle exec rake gitlab:assets:compile_webpack_if_needed RAILS_ENV=production NODE_ENV=production
      bundle exec rake gitlab:assets:fix_urls RAILS_ENV=production NODE_ENV=production
      bundle exec rake gitlab:assets:check_page_bundle_mixins_css_for_sideeffects RAILS_ENV=production NODE_ENV=production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv public/assets $out

      runHook postInstall
    '';
  };
in
stdenv.mkDerivation {
  name = "gitlab${lib.optionalString gitlabEnterprise "-ee"}-${version}";

  inherit src;

  buildInputs = [
    rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler tzdata git nettools
  ];

  patches = [
    # Change hardcoded paths to the NixOS equivalent
    ./remove-hardcoded-locations.patch

    # Use the exactly 32 byte long version of db_key_base with
    # aes-256-gcm, see
    # https://gitlab.com/gitlab-org/gitlab/-/merge_requests/53602
    (fetchpatch {
      name = "secrets_db_key_base_length.patch";
      url = "https://gitlab.com/gitlab-org/gitlab/-/commit/a5c78650441c31a522b18e30177c717ffdd7f401.patch";
      sha256 = "1qcxr5f59slgzmpcbiwabdhpz1lxnq98yngg1xkyihk2zhv0g1my";
    })
  ];

  postPatch = ''
    ${lib.optionalString (!gitlabEnterprise) ''
      # Remove all proprietary components
      rm -rf ee
    ''}

    # For reasons I don't understand "bundle exec" ignores the
    # RAILS_ENV causing tests to be executed that fail because we're
    # not installing development and test gems above. Deleting the
    # tests works though.
    rm lib/tasks/test.rake

    rm config/initializers/gitlab_shell_secret_token.rb

    sed -i '/ask_to_continue/d' lib/tasks/gitlab/two_factor.rake
    sed -ri -e '/log_level/a config.logger = Logger.new(STDERR)' config/environments/production.rb

    mv config/puma.rb.example config/puma.rb
    # Always require lib-files and application.rb through their store
    # path, not their relative state directory path. This gets rid of
    # warnings and means we don't have to link back to lib from the
    # state directory.
    ${replace}/bin/replace-literal -f -r -e '../lib' "$out/share/gitlab/lib" config
    ${replace}/bin/replace-literal -f -r -e "require_relative 'application'" "require_relative '$out/share/gitlab/config/application'" config
  '';

  buildPhase = ''
    rm -f config/secrets.yml
    mv config config.dist
    rm -r tmp
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/gitlab
    ln -sf ${assets} $out/share/gitlab/public/assets
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
    inherit rubyEnv assets;
    ruby = rubyEnv.wrappedRuby;
    GITALY_SERVER_VERSION = data.passthru.GITALY_SERVER_VERSION;
    GITLAB_PAGES_VERSION = data.passthru.GITLAB_PAGES_VERSION;
    GITLAB_SHELL_VERSION = data.passthru.GITLAB_SHELL_VERSION;
    GITLAB_WORKHORSE_VERSION = data.passthru.GITLAB_WORKHORSE_VERSION;
    tests = {
      nixos-test-passes = nixosTests.gitlab;
    };
  };

  meta = with lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin krav talyz ];
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
