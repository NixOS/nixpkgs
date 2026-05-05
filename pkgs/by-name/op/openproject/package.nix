{
  lib,
  stdenv,
  fetchFromGitHub,
  bundlerEnv,
  fetchNpmDeps,
  nodejs_22,
  npmHooks,
  ruby_3_4,
  defaultGemConfig,
  makeWrapper,
  which,
  postgresql,
  nixosTests,
  openprojectStatePath ? "/tmp/openproject",
  nix-update-script,
  _experimental-update-script-combinators,
}:

let
  version = "17.2.3";
  ruby = ruby_3_4;
  nodejs = nodejs_22;

  # Source with our gemset.nix and Gemfile.lock merged in
  # This is necessary because OpenProject has path-based gems in modules/
  src = fetchFromGitHub {
    owner = "opf";
    repo = "openproject";
    tag = "v${version}";
    hash = "sha256-GH0H4ym9RqkRMOof5iCUkylRTVNJj/GpDCUqn8uiz4E=";
    postFetch = ''
      cp ${./gemset.nix} $out/gemset.nix
      cp ${./Gemfile.lock} $out/Gemfile.lock
      cp $out/config/database.production.yml $out/config/database.yml
      cp $out/packaging/conf/configuration.yml $out/config/configuration.yml
      echo "${ruby.version}" > $out/.ruby-version
    '';
  };

  rubyEnv = bundlerEnv {
    name = "openproject-env-${version}";
    inherit ruby;
    gemdir = src;
    groups = [
      "ldap"
      "postgres"
      "production"
    ];
    extraConfigPaths = [
      "${src}/Gemfile.modules"
      "${src}/modules"
      "${src}/lib"
      "${src}/config"
      "${src}/vendor"
      "${src}/.ruby-version"
    ];
    gemConfig = defaultGemConfig;
  };

in
stdenv.mkDerivation {
  pname = "openproject";
  inherit version src;

  nativeBuildInputs = [
    makeWrapper
    which
    nodejs
    npmHooks.npmConfigHook
    rubyEnv.wrappedRuby
  ];

  npmRoot = "frontend";
  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "source/frontend";
    hash = "sha256-dWWf8ukDCFwc2UuUUqFQHhpWVyJKzo215WiU96U7SPc=";
  };

  makeCacheWritable = true;

  buildPhase = ''
    export BUNDLE_WITHOUT=development:test

    ## see <openproject/docker/prod/setup/precompile-assets.sh>
    export RAILS_ENV=production
    export DATABASE_URL=nulldb://db
    export SECRET_KEY_BASE=1

    bundle exec rails openproject:plugins:register_frontend assets:precompile

    rm -r docker files frontend log nix packaging tmp
    ln -s ${openprojectStatePath}/tmp tmp
    ln -s ${openprojectStatePath}/files files
  '';

  installPhase = ''
    cp -R . $out

    mkdir -p $out/bin

    substitute ${./web.sh.in} $out/bin/openproject-web \
      --subst-var-by openprojectStatePath ${openprojectStatePath} \
      --subst-var-by openproject $out \
      --subst-var-by shell ${stdenv.shell} \
      --subst-var-by bundle ${rubyEnv.wrappedRuby}/bin/bundle

    substitute ${./seeder.sh.in} $out/bin/openproject-seeder \
      --subst-var-by openprojectStatePath ${openprojectStatePath} \
      --subst-var-by openproject $out \
      --subst-var-by psql ${postgresql}/bin/psql \
      --subst-var-by shell ${stdenv.shell} \
      --subst-var-by bundle ${rubyEnv.wrappedRuby}/bin/bundle

    substitute ${./worker.sh.in} $out/bin/openproject-worker \
      --subst-var-by openprojectStatePath ${openprojectStatePath} \
      --subst-var-by openproject $out \
      --subst-var-by shell ${stdenv.shell} \
      --subst-var-by bundle ${rubyEnv.wrappedRuby}/bin/bundle

    substitute ${./cron-step-imap.sh.in} $out/bin/openproject-cron-step-imap \
      --subst-var-by openprojectStatePath ${openprojectStatePath} \
      --subst-var-by openproject $out \
      --subst-var-by shell ${stdenv.shell} \
      --subst-var-by bundle ${rubyEnv.wrappedRuby}/bin/bundle

    chmod +x $out/bin/*
  '';

  passthru = {
    inherit rubyEnv openprojectStatePath;
    inherit (nixosTests) openproject;
    # run with: nix-shell ./maintainers/scripts/update.nix --argstr package openproject
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
    ];
  };

  meta = {
    description = "Open-source project management web application";
    homepage = "https://www.openproject.org";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      b12f
      bendlas
      onny
      teutat3s
    ];
    license = lib.licenses.gpl3;
    mainProgram = "openproject-web";
  };
}
