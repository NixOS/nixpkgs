{
  stdenv,
  lib,
  fetchFromGitHub,
  bundlerEnv,
  nixosTests,
  ruby_3_4,
  pdfium-binaries,
  makeWrapper,
  bundler,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docuseal";
  version = "2.1.7";

  bundler = bundler.override { ruby = ruby_3_4; };

  src = fetchFromGitHub {
    owner = "docusealco";
    repo = "docuseal";
    tag = finalAttrs.version;
    hash = "sha256-zNfxQPJjobYrx/YPGRn5QKwUd1VXetFqtBeII0wlmk4=";
    # https://github.com/docusealco/docuseal/issues/505#issuecomment-3153802333
    postFetch = "rm $out/db/schema.rb";
  };

  rubyEnv = bundlerEnv {
    name = "docuseal-gems";
    ruby = ruby_3_4;
    inherit (finalAttrs) bundler;
    gemdir = ./.;
  };

  docusealWeb = stdenv.mkDerivation {
    pname = "docuseal-web";
    inherit (finalAttrs)
      version
      src
      meta
      ;

    offlineCache = fetchYarnDeps {
      yarnLock = ./yarn.lock;
      hash = "sha256-IQOWLkVueuRs0CBv3lEdj6DOiumC4ZPuQRDxQHFh5fQ=";
    };

    nativeBuildInputs = [
      yarn
      fixup-yarn-lock
      nodejs
      finalAttrs.rubyEnv
    ];

    RAILS_ENV = "production";
    NODE_ENV = "production";

    # no idea how to patch ./bin/shakapacker. instead we execute the two bundle exec commands manually
    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      fixup-yarn-lock yarn.lock

      yarn config --offline set yarn-offline-mirror $offlineCache

      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
      patchShebangs node_modules

      bundle exec rails assets:precompile
      bundle exec rails shakapacker:compile

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r public/packs $out

      runHook postInstall
    '';
  };

  buildInputs = [ finalAttrs.rubyEnv ];
  propagatedBuildInputs = [ finalAttrs.rubyEnv.wrappedRuby ];
  nativeBuildInputs = [ makeWrapper ];

  RAILS_ENV = "production";
  BUNDLE_WITHOUT = "development:test";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/public/packs
    cp -r ${finalAttrs.src}/* $out
    cp -r ${finalAttrs.docusealWeb}/* $out/public/packs

    bundle exec bootsnap precompile --gemfile app/ lib/

    runHook postInstall
  '';

  # create empty folder which are needed, but never used
  postInstall = ''
    chmod +w $out/tmp/
    mkdir -p $out/tmp/{cache,sockets}
  '';

  postFixup = ''
    wrapProgram $out/bin/rails \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pdfium-binaries ]}"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) docuseal-psql docuseal-sqlite;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Open source tool for creating, filling and signing digital documents";
    homepage = "https://www.docuseal.co/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ stunkymonkey ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
