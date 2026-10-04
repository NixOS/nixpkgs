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
  version = "17.9.1";

  src = fetchFromGitHub {
    owner = "opf";
    repo = "openproject";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b7mLJ0IAYpmHoflYiO1AML7ELMZChruh3ON0P1JNBDw=";
  };

  passthru.patchedSrc = applyPatches {
    inherit (finalAttrs) src;
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
    hash = "sha256-Pu52+14G9EmT/DQc3iB1Ve1DRWZsirs2byr068Ovrjo=";
  };

  rubyEnv = bundlerEnv {
    name = "openproject-env-${finalAttrs.version}";
    inherit ruby;
    gemfile = "${finalAttrs.passthru.patchedSrc}/Gemfile";
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    groups = [
      "ldap"
      "postgres"
      "production"
    ];
    extraConfigPaths = [
      "${finalAttrs.passthru.patchedSrc}/Gemfile.modules"
      "${finalAttrs.passthru.patchedSrc}/modules"
      "${finalAttrs.passthru.patchedSrc}/lib"
      "${finalAttrs.passthru.patchedSrc}/config"
      "${finalAttrs.passthru.patchedSrc}/vendor"
      "${finalAttrs.passthru.patchedSrc}/.ruby-version"
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
