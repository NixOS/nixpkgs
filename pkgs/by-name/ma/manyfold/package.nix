{
  assimp,
  bundlerEnv,
  dart-sass,
  fetchFromGitHub,
  lib,
  libarchive,
  nodejs_22,
  ruby_3_4,
  stdenvNoCC,
  writeTextDir,
  yarn-berry_3,
}:
let
  yarn-berry = yarn-berry_3;
  ruby = ruby_3_4;
  gems = bundlerEnv {
    name = "manyfold-env";
    inherit ruby;
    gemdir = ./.;
    extraConfigPaths = [
      "${writeTextDir ".ruby-version" ruby.version}/.ruby-version"
    ];
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "manyfold";
  version = "0.129.1";

  src = fetchFromGitHub {
    owner = "manyfold3d";
    repo = "manyfold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L/kM5A47DxypckTYRno9qK4hYYD9HC6CXxIzCRlOAWU=";
  };

  prePatch = ''
    echo ${gems.ruby.version} >.ruby-version
    substituteInPlace Gemfile.lock \
      --replace-fail '   ruby 3.4.1p0' "   ruby ${gems.ruby.version}" \
      --replace-fail '   2.6.2' "   ${gems.bundler.version}"
  '';

  nativeBuildInputs = [
    nodejs_22
    ruby
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-Hrw7+1DOkKuoq4IUR/Gr/wMVjAPHGdI0nElYAgqAvnU=";
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

  meta = {
    description = "ActivityPub-powered tool for storing and sharing 3d models";
    homepage = "https://manyfold.app/";
    downloadPage = "https://github.com/manyfold3d/manyfold";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
    teams = [ lib.teams.ngi ];
  };
})
