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
  yarnConfigHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docuseal";
  version = "2.3.4";

  bundler = bundler.override { ruby = ruby_3_4; };

  src = fetchFromGitHub {
    owner = "docusealco";
    repo = "docuseal";
    tag = finalAttrs.version;
    hash = "sha256-JKV0xAtEbGETprC5zYEcmCVcUFrW4h/+lbYayzWefKs=";
    # https://github.com/docusealco/docuseal/issues/505#issuecomment-3153802333
    postFetch = "rm $out/db/schema.rb";
  };

  patches = [
    # Drop setxid calls in non-root mode (fails under strict seccomp).
    # https://github.com/docusealco/docuseal/pull/593
    ./only-switch-uid-when-root.patch
  ];

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
      inherit (finalAttrs) src;
      hash = "sha256-AvdaSIXO31t15wWysTvFISqmKCAi1Q8CJgO0J2DqM6M=";
    };

    nativeBuildInputs = [
      yarn
      yarnConfigHook
      nodejs
      finalAttrs.rubyEnv
    ];

    RAILS_ENV = "production";
    NODE_ENV = "production";

    # no idea how to patch ./bin/shakapacker. instead we execute the two bundle exec commands manually
    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)

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
  nativeBuildInputs = [
    makeWrapper
  ];

  env = {
    RAILS_ENV = "production";
    BUNDLE_WITHOUT = "development:test";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/public/packs
    cp -r ./* $out
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
