{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  bundlerEnv,
  fetchNpmDeps,
  nodejs_22,
  npmHooks,
  ruby_3_4,
  rust,
  rustc,
  writeShellScriptBin,
  defaultGemConfig,
  buildRubyGem,
  makeWrapper,
  which,
  nixosTests,
  openprojectStatePath ? "/tmp/openproject",
}:

let
  version = "17.0.1";
  commonmarkerCargoDepsHash = "sha256-Osj+WzyTQlcMtgkqvhRquLkVMK4z2HYafr4t42qsxe8=";
  ## check upstream .ruby-version when updating,
  ## because that's overridden in the recipe (to override minor version mismatch)
  opf-ruby = ruby_3_4;
  nodejs = nodejs_22;

  rustPackages = rust.packages.stable;
  rustPlatform = rustPackages.rustPlatform;

  rubyEnv = bundlerEnv {
    name = "openproject-env-${version}";

    ruby = opf-ruby;
    gemdir = src;
    groups = [
      # "development" "test"
      "ldap"
      "postgres"
      "production"
      # "markdown" "common_mark" "minimagick"
    ];
    extraConfigPaths = [
      "${src}/Gemfile.modules"
      "${src}/modules"
      "${src}/lib"
      "${src}/config"
      "${src}/vendor"
      "${src}/.ruby-version"
    ];
    gemConfig = defaultGemConfig // {

      commonmarker = attrs: {
        cargoDeps = rustPlatform.fetchCargoVendor {
          ## Uglyhack gem unpack
          ## see <nixpkgs/pkgs/development/ruby-modules/gem>
          src =
            runCommand "commonmarker-src"
              {
                inherit (buildRubyGem attrs) src;
              }
              ''
                ${opf-ruby}/bin/gem unpack $src --target=container
                cp -R container/* $out
              '';
          name = "commonmarker-cargodeps";
          hash = commonmarkerCargoDepsHash;
        };
        dontBuild = false; # # so that we get rust source
        preInstall = attrs.preInstall or "" + ''
          export PATH="${writeShellScriptBin "cargo" ''
            set -x
            exec env CARGO_NET_OFFLINE=true HOME=/build ${rustPackages.cargo}/bin/cargo "$@"
          ''}/bin:$PATH"
        '';
        nativeBuildInputs = attrs.nativeBuildInputs or [ ] ++ [
          rustPlatform.cargoSetupHook
          rustPlatform.bindgenHook
        ];
      };

    };
  };

  origSrc = fetchFromGitHub {
    owner = "opf";
    repo = "openproject";
    tag = "v${version}";
    hash = "sha256-kNbB4kIY+2fjd978PsQdWu/huqs93KyBl9668kHbGas=";
  };

  src =
    runCommand "openproject-${version}-src" {}
      ''
        cp -R ${origSrc} $out
        chmod -R u+w $out
        cp ${./rubyEnv/gemset.nix} $out/gemset.nix
        cp $out/config/database.production.yml $out/config/database.yml
        cp $out/packaging/conf/configuration.yml $out/config/configuration.yml
        cd $out
        patchPhase
        echo "${opf-ruby.version}" > .ruby-version
        sed -i "s/^   ruby .*\$/   ruby ${opf-ruby.version}/" Gemfile.lock
      '';

in
stdenv.mkDerivation (finalAttrs: {
  pname = "openproject";
  version = "17.0.1";

  src = fetchFromGitHub {
    owner = "opf";
    repo = "openproject";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kNbB4kIY+2fjd978PsQdWu/huqs93KyBl9668kHbGas=";
  };

  nativeBuildInputs = [
    makeWrapper
    which
    nodejs
    npmHooks.npmConfigHook
    rubyEnv.wrappedRuby
  ];

  npmRoot = "frontend";
  npmDeps = fetchNpmDeps {
    src = src + "/frontend";
    hash = "sha256-kCRmd/dgY2PbnyIbpsfyYgAJdjx7sXTqmRlUxsnClUc=";
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
  '';

  passthru = {
    inherit rubyEnv openprojectStatePath;
    inherit (nixosTests) openproject;
  };

  meta = {
    description = "Open-source project management web application";
    homepage = "https://www.openproject.org";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bendlas
      onny
    ];
    license = lib.licenses.gpl3;
  };
})
