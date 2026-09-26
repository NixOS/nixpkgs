{
  lib,
  stdenv,
  fetchFromGitHub,
  bundlerEnv,
  fetchNpmDeps,
  nodejs_26,
  npmHooks,
  ruby_4_0,
  defaultGemConfig,
  makeWrapper,
  which,
  postgresql,
  nixosTests,
  nix-update-script,
  _experimental-update-script-combinators,
  applyPatches,
}:

let
  ruby = ruby_4_0;
  nodejs = nodejs_26;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openproject";
  version = "17.6.0";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "opf";
      repo = "openproject";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Mi6IqReSDeGIgmqlH2Hfk94b7G8vMoMN6WMBjTQOXJs=";
    };
    patches = [
      # bundix and bundlerEnv fail with system-specific gems
      # patch gemfile.lock with
      # bundle config set --local force_ruby_platform true
      # bundle lock --remove-platform aarch64-linux aarch64-linux-gnu aarch64-linux-musl \
      #  arm-linux-gnu arm-linux-musl arm64-darwin \
      #  x86_64-darwin x86_64-linux x86_64-linux-gnu x86_64-linux-musl
      ./0001-build-source-gem-only.patch
    ];
    postPatch = ''
      substituteInPlace ./Gemfile \
        --replace-fail "ruby File.read(File.expand_path(\".ruby-version\", __dir__)).strip" "ruby '>= 4.0.0'"
    '';
  };

  nativeBuildInputs = [
    makeWrapper
    which
    nodejs
    npmHooks.npmConfigHook
    finalAttrs.rubyEnv.wrappedRuby
  ];

  npmRoot = "frontend";
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/frontend";
    hash = "sha256-9Yk07lTG+2/PKUfMU6AKGkBTuv0N4Jq65+gY/YVNOYg=";
  };

  rubyEnv = bundlerEnv {
    name = "openproject-env-${finalAttrs.version}";
    inherit ruby;
    gemfile = "${finalAttrs.src}/Gemfile";
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    groups = [
      "ldap"
      "postgres"
      "production"
    ];
    extraConfigPaths = [
      "${finalAttrs.src}/Gemfile.modules"
      "${finalAttrs.src}/modules"
      "${finalAttrs.src}/lib"
      "${finalAttrs.src}/config"
      "${finalAttrs.src}/vendor"
      "${finalAttrs.src}/.ruby-version"
    ];
    gemConfig = defaultGemConfig;
  };
  makeCacheWritable = true;

  buildPhase = ''
    export BUNDLE_WITHOUT=development:test

    # see <openproject/docker/prod/setup/precompile-assets.sh>
    export RAILS_ENV=production
    export DATABASE_URL=nulldb://db
    export SECRET_KEY_BASE=1

    bundle exec rails openproject:plugins:register_frontend assets:precompile

    rm -r docker files frontend log nix packaging tmp
    ln -sf /run/openproject/tmp tmp
    ln -sf /run/openproject/files files
  '';

  installPhase = ''
    cp -R . $out
  '';

  passthru = {
    inherit (finalAttrs) rubyEnv;
    inherit (nixosTests) openproject;
    # run with: nix-shell ./maintainers/scripts/update.nix --argstr package openproject
    # Before running the update, update the patch file above first.
    # Some hashes for commonmarker, ffi or nokogiri might have to be updated manually,
    # if building fails.
    # Put the correct hash from nix build and insert it for the specific gem into
    # gemset.nix or pkgs/development/ruby-modules/gem-config/default.nix
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      ./update.sh
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
  };
})
