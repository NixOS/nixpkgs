{
  assimp,
  bundlerEnv,
  dart-sass,
  f3d,
  fetchFromGitHub,
  imagemagick,
  lib,
  libarchive,
  nodejs_24,
  ruby_3_4,
  runCommand,
  stdenvNoCC,
  writeTextDir,
  yarn-berry_3,
  nixosTests,
}:
let
  yarn-berry = yarn-berry_3;
  ruby = ruby_3_4;
  lockfile = runCommand "Gemfile.lock" { } ''
    sed -E 's/ruby [0-9]+\.[0-9]+\.[0-9]+/ruby ${ruby.version}/' ${./Gemfile.lock} > $out
  '';
  gems = bundlerEnv {
    name = "manyfold-env";
    inherit ruby lockfile;
    gemdir = ./.;
    gemset = lib.recursiveUpdate (import ./gemset.nix) {
      byebug.platforms = [ ];
      concurrent-ruby.platforms = [ ];
      tzinfo-data.platforms = [ ];
      tzinfo.platforms = [ ];
    };
    groups = [
      "production"
      "sqlite3"
      "postgres"
      "mysql"
    ];
    extraConfigPaths = [
      "${writeTextDir ".ruby-version" ruby.version}/.ruby-version"
    ];
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "manyfold";
  version = "0.153.0";

  src = fetchFromGitHub {
    owner = "manyfold3d";
    repo = "manyfold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hOt8IKAmvddnc4Wh0GxmNUymFPUA+soUzsSY26HDz+w=";
  };

  prePatch = ''
    echo ${gems.ruby.version} >.ruby-version
    cp -f ${lockfile} Gemfile.lock
    chmod +w Gemfile.lock

    substituteInPlace app/lib/file_handlers/f3d_cli.rb \
      --replace-fail '`f3d --list-readers`' '`${lib.getExe f3d} --list-readers`'
    substituteInPlace app/lib/thumbnailers/f3d.rb \
      --replace-fail 'Open3.capture3("f3d"' 'Open3.capture3("${lib.getExe f3d}"'
    substituteInPlace app/uploaders/application_uploader.rb \
      --replace-fail 'Open3.capture3("f3d"' 'Open3.capture3("${lib.getExe f3d}"'
    substituteInPlace app/lib/file_handlers/image_magick.rb \
      --replace-fail '`magick -list format`' '`${lib.getExe imagemagick} -list format`'
  '';

  nativeBuildInputs = [
    f3d
    imagemagick
    nodejs_24
    gems.ruby
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-iQxlmCWx91SGfhFqYzxH627XPgG0GNJzVtEw5HfoqGs=";
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
