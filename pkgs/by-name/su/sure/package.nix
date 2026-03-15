{
  applyPatches,
  lib,
  bundlerEnv,
  fetchFromGitHub,
  ruby_3_4,
  stdenv,
  tailwindcss_4,
}:
let
  sources = lib.importJSON ./sources.json;
  inherit (sources) version;

  src = applyPatches {
    src = fetchFromGitHub {
      inherit (sources)
        owner
        repo
        hash
        ;
      tag = sources.version;
    };
    postPatch = ''
      cp -f ${./rubyEnv/Gemfile} ./Gemfile
      cp -f ${./rubyEnv/Gemfile.lock} ./Gemfile.lock
    '';
  };

  rubyEnv = bundlerEnv rec {
    name = "sure-ruby-env-${version}";
    ruby = ruby_3_4;
    inherit version;
    gemdir = src;
    gemset = ./rubyEnv/gemset.nix;
  };
in
stdenv.mkDerivation rec {
  pname = "sure";
  inherit src version;

  env = {
    RAILS_ENV = "production";
    BUNDLE_DEPLOYTMENT = "1";
    BUNDLE_WITHOUT = "development";
    TAILWINDCSS_INSTALL_DIR = "${tailwindcss_4}/bin";
  };

  buildInputs = [
    rubyEnv
    rubyEnv.wrappedRuby
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs bin/

    bundle exec bootsnap precompile --gemfile -j 0
    bundle exec bootsnap precompile -j 0 app/ lib/

    SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r {public,bin,app,config,db,lib,vendor} $out/
    cp -r {Rakefile,config.ru} $out/

    ln -s /run/sure/tmp $out/tmp
    ln -s /run/sure/log $out/log
    ln -s /run/sure/storage $out/storage

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://github.com/we-promise/sure/releases/tag/v${version}";
    description = "Personal finance app for everyone";
    homepage = "https://sure.am/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pjrm
    ];
    platforms = lib.platforms.linux;
  };
}
