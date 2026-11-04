{
  assimp,
  bundlerEnv,
  dart-sass,
  fetchFromGitHub,
  lib,
  libarchive,
  nodejs_24,
  ruby_3_4,
  stdenvNoCC,
  writeTextDir,
  yarn-berry_3,
  nixosTests,
}:
let
  yarn-berry = yarn-berry_3;
  ruby = ruby_3_4;
  gems = bundlerEnv {
    name = "manyfold-env";
    inherit ruby;
    gemdir = ./.;
    gemset = lib.recursiveUpdate (import ./gemset.nix) {
      byebug.platforms = [ ];
      concurrent-ruby.platforms = [ ];
      tzinfo-data.platforms = [ ];
      tzinfo.platforms = [ ];
    };
    groups = [ "production" ];
    extraConfigPaths = [
      "${writeTextDir ".ruby-version" ruby.version}/.ruby-version"
    ];
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "manyfold";
  version = "0.134.0";

  src = fetchFromGitHub {
    owner = "manyfold3d";
    repo = "manyfold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JFPfJYzJuQJCpxbu6HVlBy1m+D8nyuTGeVt5G0jFAl4=";
  };

  prePatch = ''
    echo ${gems.ruby.version} >.ruby-version
    substituteInPlace Gemfile.lock \
      --replace-fail '   ruby 3.4.8p72' "   ruby ${gems.ruby.version}" \
      --replace-fail '   2.6.2' "   ${gems.bundler.version}"
  '';

  nativeBuildInputs = [
    nodejs_24
    gems.ruby
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-poS/exOkwRVOrWS0jX711eD/gkheyKDBpw13+w02J40=";
  };

  # dynamically loaded by ruby gems
  env.LD_LIBRARY_PATH = lib.makeLibraryPath [
    assimp
    libarchive
  ];

  preBuild = ''
    mkdir -p vendor/bundle/ruby
    ln -s ${gems}/${ruby.gemPath} vendor/bundle/ruby/

    bundle config set deployment true
    bundle config set without "development test"

    # force sass-embedded to use our own sass instead of the bundled one
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
        --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
  '';

  buildPhase = ''
    runHook preBuild

    touch db/schema.rb

    export DATABASE_URL="nulldb://user:pass@localhost/db"
    export SECRET_KEY_BASE="placeholder"
    export RACK_ENV="production"
    export RAILS_ASSETS_PRECOMPILE=1

    bundle exec rake assets:precompile

    rm db/schema.rb

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ln -s ${gems}/bin $out/

    mkdir -p $out/lib/manyfold
    cp -r . $out/lib/manyfold/

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) manyfold;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "ActivityPub-powered tool for storing and sharing 3d models";
    homepage = "https://manyfold.app/";
    downloadPage = "https://github.com/manyfold3d/manyfold";
    license = lib.licenses.mit;
    teams = [ lib.teams.ngi ];
  };
})
