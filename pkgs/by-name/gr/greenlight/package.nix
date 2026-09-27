{
  lib,
  stdenv,
  fetchFromGitHub,
  bundlerEnv,
  fetchNpmDeps,
  nodejs_26,
  npmHooks,
  ruby_3_3,
  makeWrapper,
  which,
  nixosTests,
  nix-update-script,
  _experimental-update-script-combinators,
}:

let
  ruby = ruby_3_3;
  nodejs = nodejs_26;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "greenlight";
  version = "3.8.2.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bigbluebutton";
    repo = "greenlight";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-GOgOEP6dx1E/rIe4HBR35TM294ad8ywcBXVea1xFOag=";
  };

  patches = [
    # Expose further Rails development configurations as env vars
    ./expose_rails_dev_configs.patch
  ];

  postPatch = ''
    # jsbundling-rails dependency would executes yarn install but
    # we'll stick with npm
    rm -f yarn.lock

    substituteInPlace "config/storage.yml" --replace-fail \
      'root: <%= Rails.root.join("storage") %>' \
      'root: "/var/lib/greenlight/storage"'

    substituteInPlace "config/environments/development.rb" --replace-fail \
      '  config.hosts = nil' \
      '  config.hosts = nil; config.paths["log"] = ["/var/log/greenlight/development.log"]'
  '';

  nativeBuildInputs = [
    makeWrapper
    which
    nodejs
    npmHooks.npmConfigHook
    finalAttrs.rubyEnv.wrappedRuby
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-aTDd6+mc3DIE5FiaPVjjorJ0r8RfodhEVCs3o2zHbZk=";
  };

  rubyEnv = bundlerEnv {
    name = "greenlight-env-${finalAttrs.version}";
    inherit ruby;
    gemfile = "${finalAttrs.src}/Gemfile";
    # Manually need to remove platform not supported by bundix
    # See https://github.com/bigbluebutton/greenlight/pull/6317
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    groups = [ "production" ];
  };
  makeCacheWritable = true;

  buildPhase = ''
    runHook preBuild

    export BUNDLE_WITHOUT=development:test
    export SECRET_KEY_BASE=1
    bundle exec rails assets:precompile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/greenlight $out/bin
    cp -r app bin config config.ru db lib public vendor Gemfile Gemfile.lock Rakefile $out/share/greenlight/
    ln -s $out/share/greenlight/lib $out/lib
    ln -s $out/share/greenlight/bin $out/bin
    ln -sf /tmp $out/share/greenlight/tmp

    runHook postInstall
  '';

  passthru = {
    inherit (finalAttrs) rubyEnv;
    tests = { inherit (nixosTests) greenlight; };
    # run with: nix-shell ./maintainers/scripts/update.nix --argstr package greenlight
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      ./update.sh
    ];
  };

  meta = {
    description = "End-user web interface for BigBlueButton server";
    homepage = "https://github.com/bigbluebutton/greenlight";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.onny ];
    teams = [ lib.teams.ngi ];
  };
})
