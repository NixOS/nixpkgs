{
  lib,
  beamPackages,
  buildNpmPackage,
  rustPlatform,
  fetchFromGitHub,
  nodejs,
  runCommand,
  nixosTests,
  npm-lockfile-fix,
  nix-update-script,
  brotli,
  tailwindcss_3,
  esbuild,
  buildPackages,
}:

let
  pname = "plausible";
  version = "3.0.1";
  mixEnv = "ce";

  src = fetchFromGitHub {
    owner = "plausible";
    repo = "analytics";
    rev = "v${version}";
    hash = "sha256-DQIRsqkH2zgIkb3yezuJEKJ99PS031GJ+bDAeHMLNUY=";
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/assets/package-lock.json
      sed -ie '
        /defp deps do/ {
          n
          /\[/ a\
            \{:rustler, ">= 0.0.0", optional: true \},
          }
      ' $out/mix.exs
      cat >> $out/config/config.exs <<EOF
      config :mjml, Mjml.Native,
        crate: :mjml_nif,
        skip_compilation?: true
      EOF
    '';
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version;
    src = "${src}/assets";
    npmDepsHash = "sha256-hPbKEC8DE/gb483COG/ZbTuEP8Y44Fs7ppHMpXphCjg=";
    dontNpmBuild = true;
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };

  tracker = buildNpmPackage {
    pname = "${pname}-tracker";
    inherit version;
    src = "${src}/tracker";
    npmDepsHash = "sha256-kfqJVUw3xnMT0sOkc5O42CwBxPQXiYnOQ5WpdZwzxfE";
    dontNpmBuild = true;
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit
      pname
      version
      src
      mixEnv
      ;
    hash = "sha256-caCbuMEDsLcxm8xehWEJiaTfgl435crBfnQFQpzGsLY";
  };

  mjmlNif = rustPlatform.buildRustPackage {
    pname = "mjml-native";
    version = "";
    src = "${mixFodDeps}/mjml/native/mjml_nif";

    cargoHash = "sha256-zDWOik65PWAMpIDDcG+DibprPVW/k+Q83+fjFI5vWaY=";
    doCheck = false;

    env = {
      RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
      RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "unused-but-required";
    };
  };

  patchedMixFodDeps =
    runCommand mixFodDeps.name
      {
        inherit (mixFodDeps) hash;
      }
      ''
        mkdir $out
        cp -r --no-preserve=mode ${mixFodDeps}/. $out

        mkdir -p $out/mjml/priv/native
        for lib in ${mjmlNif}/lib/*
        do
          # normalies suffix to .so, otherswise build would fail on darwin
          file=''${lib##*/}
          base=''${file%.*}
          ln -s "$lib" $out/mjml/priv/native/$base.so
        done
      '';

in
beamPackages.mixRelease rec {
  inherit
    pname
    version
    src
    mixEnv
    ;

  nativeBuildInputs = [
    nodejs
    brotli
  ];

  mixFodDeps = patchedMixFodDeps;

  passthru = {
    tests = {
      inherit (nixosTests) plausible;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "-s"
        "tracker"
        "-s"
        "assets"
        "-s"
        "mjmlNif"
      ];
    };
    inherit
      assets
      tracker
      mjmlNif
      ;
  };

  env = {
    APP_VERSION = version;
    RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
    RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "unused-but-required";
  };

  preBuild = ''
    rm -r assets tracker
    cp --no-preserve=mode -r ${assets} assets
    cp -r ${tracker} tracker

    # Fix cross-compilation with buildPackages
    # since tailwindcss_3 is not available for RiscV
    cat >> config/config.exs <<EOF
    config :tailwind, path: "${lib.getExe buildPackages.tailwindcss_3}"
    config :esbuild, path: "${lib.getExe esbuild}"
    EOF
  '';

  postBuild = ''
    npm run deploy --prefix ./tracker

    # for external task you need a workaround for the no deps check flag
    # https://github.com/phoenixframework/phoenix/issues/2690
    mix do deps.loadpaths --no-deps-check, assets.deploy
    mix do deps.loadpaths --no-deps-check, phx.digest priv/static
  '';

  meta = {
    license = lib.licenses.agpl3Plus;
    homepage = "https://plausible.io/";
    changelog = "https://github.com/plausible/analytics/blob/${src.rev}/CHANGELOG.md";
    description = "Simple, open-source, lightweight (< 1 KB) and privacy-friendly web analytics alternative to Google Analytics";
    mainProgram = "plausible";
    teams = with lib.teams; [ cyberus ];
    platforms = lib.platforms.unix;
  };
}
