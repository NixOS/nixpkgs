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
  brotli,
  tailwindcss,
  esbuild,
  ...
}:

let
  pname = "plausible";
  version = "2.1.4";
  mixEnv = "ce";

  src = fetchFromGitHub {
    owner = "plausible";
    repo = "analytics";
    rev = "v${version}";
    hash = "sha256-wV2zzRKJM5pQ06pF8vt1ieFqv6s3HvCzNT5Hed29Owk=";
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
    npmDepsHash = "sha256-Rf1+G9F/CMK09KEh022vHe02FADJtARKX4QEVbmvSqk=";
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
    npmDepsHash = "sha256-ng0YpBZc0vcg5Bsr1LmgXtzNCtNV6hJIgLt3m3yRdh4=";
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
    hash = "sha256-N6cYlYwNss2FPYcljANJYbXobmLFauZ64F7Sf/+7Ctg=";
  };

  mjmlNif = rustPlatform.buildRustPackage {
    pname = "mjml-native";
    version = "";
    src = "${mixFodDeps}/mjml/native/mjml_nif";
    cargoHash = "sha256-W4r8W+JGTE6j4gDogL5Yulr0mbaXjDbwDTwhzMbbDcQ=";
    doCheck = false;

    env = {
      RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
      RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "unused-but-required";
    };
  };

  patchedMixFodDeps = runCommand mixFodDeps.name { } ''
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
    updateScript = ./update.sh;
    inherit assets tracker;
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

    cat >> config/config.exs <<EOF
    config :tailwind, path: "${lib.getExe tailwindcss}"
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

  meta = with lib; {
    license = licenses.agpl3Plus;
    homepage = "https://plausible.io/";
    changelog = "https://github.com/plausible/analytics/blob/${src.rev}/CHANGELOG.md";
    description = " Simple, open-source, lightweight (< 1 KB) and privacy-friendly web analytics alternative to Google Analytics";
    mainProgram = "plausible";
    maintainers = teams.cyberus.members;
    platforms = platforms.unix;
  };
}
