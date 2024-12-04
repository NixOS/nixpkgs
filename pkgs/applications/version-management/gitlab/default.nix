{ bundlerEnv
, cacert
, defaultGemConfig
, fetchFromGitLab
, fetchYarnDeps
, fixup-yarn-lock
, git
, gitlabEnterprise ? false
, lib
, makeWrapper
, nettools
, nixosTests
, nodejs
, replace
, ruby_3_2
, stdenv
, tzdata
, yarn

# gem dependencies:
# gitlab-glfm-markdown
, buildRubyGem, cargo, rustc, rustPlatform

# gpgme
, pkg-config

# openssl
, openssl

# ruby-magic
, file

# static-holmes
, icu, which, zlib
}:

let
  data = lib.importJSON ./data.json;

  version = data.version;
  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  rubyEnv = bundlerEnv rec {
    name = "gitlab-env-${version}";
    ruby = ruby_3_2;
    gemdir = ./rubyEnv;
    gemset = import (gemdir + "/gemset.nix") src;
    gemConfig = defaultGemConfig // {
        gpgme = attrs: {
          nativeBuildInputs = [ pkg-config ];
        };
        # the openssl needs the openssl include files
        openssl = attrs: {
          buildInputs = [ openssl ];
        };
        ruby-magic = attrs: {
          buildInputs = [ file ];
          buildFlags = [ "--enable-system-libraries" ];
        };
        gitlab-glfm-markdown = attrs: {
          cargoDeps = rustPlatform.fetchCargoTarball {
            src = stdenv.mkDerivation {
              inherit (buildRubyGem { inherit (attrs) gemName version source; })
                name
                src
                unpackPhase
                nativeBuildInputs
              ;
              dontBuilt = true;
              installPhase = ''
                cp -R ext/glfm_markdown $out
                cp Cargo.lock $out
              '';
            };
            hash = "sha256-VYjCYUikORuXx27OYWyumBxeHw9aj/S1wcr9vLIsXeo=";
          };

          dontBuild = false;

          nativeBuildInputs = [
            cargo
            rustc
            rustPlatform.cargoSetupHook
            rustPlatform.bindgenHook
          ];

          disallowedReferences = [
            rustc.unwrapped
          ];

          preInstall = ''
            export CARGO_HOME="$PWD/../.cargo/"
          '';

          postInstall = ''
            mv -v $GEM_HOME/gems/${attrs.gemName}-${attrs.version}/lib/{glfm_markdown/glfm_markdown.so,}
            find $out -type f -name .rustc_info.json -delete
          '';
        };

        static_holmes = attrs: {
          nativeBuildInputs = [
            icu
            which
            zlib.dev
          ];
        };
      };
    groups = [
      "default" "unicorn" "ed25519" "metrics" "development" "puma" "test" "kerberos" "opentelemetry"
    ];
    # N.B. omniauth_oauth2_generic and apollo_upload_server both provide a
    # `console` executable.
    ignoreCollisions = true;

    extraConfigPaths = [ "${src}/vendor" "${src}/gems" ];
  };

  assets = stdenv.mkDerivation {
    pname = "gitlab-assets";
    inherit version src;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      sha256 = data.yarn_hash;
    };

    nativeBuildInputs = [ rubyEnv.wrappedRuby rubyEnv.bundler nodejs yarn git cacert fixup-yarn-lock ];

    patches = [
      # Since version 12.6.0, the rake tasks need the location of git,
      # so we have to apply the location patches here too.
      ./remove-hardcoded-locations.patch

      # Gitlab edited the default database config since [1] and the
      # installer now complains about valid keywords only being "main", "ci" and "embedded".
      #
      # [1]: https://gitlab.com/gitlab-org/gitlab/-/commit/99c0fac52b10cd9df62bbe785db799352a2d9028
      ./Remove-unsupported-database-names.patch
    ];
    # One of the patches uses this variable - if it's unset, execution
    # of rake tasks fails.
    GITLAB_LOG_PATH = "log";
    FOSS_ONLY = !gitlabEnterprise;

    SKIP_YARN_INSTALL = 1;

    configurePhase = ''
      runHook preConfigure

      # Some rake tasks try to run yarn automatically, which won't work
      rm lib/tasks/yarn.rake

      # The rake tasks won't run without a basic configuration in place
      mv config/database.yml.postgresql config/database.yml
      mv config/gitlab.yml.example config/gitlab.yml

      # Yarn and bundler wants a real home directory to write cache, config, etc to
      export HOME=$NIX_BUILD_TOP/fake_home

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror $yarnOfflineCache

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      fixup-yarn-lock yarn.lock

      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive

      patchShebangs node_modules/
      patchShebangs scripts/frontend/

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      bundle exec rake gitlab:assets:compile RAILS_ENV=production NODE_ENV=production SKIP_YARN_INSTALL=true

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

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler tzdata git nettools
  ];

  patches = [
    # Change hardcoded paths to the NixOS equivalent
    ./remove-hardcoded-locations.patch
  ];

  postPatch = ''
    ${lib.optionalString (!gitlabEnterprise) ''
      # Remove all proprietary components
      rm -rf ee
      sed -i 's/-ee//' ./VERSION
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
    ${replace}/bin/replace-literal -f -r -e '../../lib' "$out/share/gitlab/lib" config
    ${replace}/bin/replace-literal -f -r -e '../lib' "$out/share/gitlab/lib" config
    ${replace}/bin/replace-literal -f -r -e "require_relative 'application'" "require_relative '$out/share/gitlab/config/application'" config
    ${replace}/bin/replace-literal -f -r -e 'require_relative "/home/git/gitlab/lib/gitlab/puma/error_handler"' "require_relative '$out/share/gitlab/lib/gitlab/puma/error_handler'" config
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

    # manually patch the shebang line in generate-loose-foreign-key
    wrapProgram $out/share/gitlab/scripts/decomposition/generate-loose-foreign-key --set ENABLE_SPRING 0 --add-flags 'runner -e test'
  '';

  passthru = {
    inherit rubyEnv assets;
    ruby = rubyEnv.wrappedRuby;
    GITALY_SERVER_VERSION = data.passthru.GITALY_SERVER_VERSION;
    GITLAB_PAGES_VERSION = data.passthru.GITLAB_PAGES_VERSION;
    GITLAB_SHELL_VERSION = data.passthru.GITLAB_SHELL_VERSION;
    GITLAB_WORKHORSE_VERSION = data.passthru.GITLAB_WORKHORSE_VERSION;
    gitlabEnv.FOSS_ONLY = lib.boolToString (!gitlabEnterprise);
    tests = {
      nixos-test-passes = nixosTests.gitlab;
    };
  };

  meta = with lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = teams.gitlab.members;
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
