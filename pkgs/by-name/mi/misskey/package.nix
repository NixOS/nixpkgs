{
  stdenv,
  lib,
  nixosTests,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  python3,
  dart-sass,
  node-gyp,
  bash,
  jemalloc,
  ffmpeg-headless,
  writeShellScript,
}:
let
  pnpm = pnpm_12;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "misskey";
  version = "2026.11.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "misskey-dev";
    repo = "misskey";
    tag = finalAttrs.version;
    hash = "sha256-Pwsj4UeoA8J2TPwqYtGdfbggm0COsiPVNW4tQZF1dZE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeWrapper
    python3
    dart-sass
    node-gyp # for sharp and re2
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-zm25NWE+NaklRK/vc8Ti28QdDINqFp17MkT1uWuDF0M=";
  };

  # config.verify-deps-before-run during build time
  env.PNPM_CONFIG_VERIFY_DEPS_BEFORE_RUN = false;

  preBuild = ''
    # In darwin sandboxed build, scripts will try to call preinstalled sed outside of the sandbox
    patchShebangs packages/*/node_modules/.bin
    patchShebangs packages/*/*/node_modules/.bin
    patchShebangs packages-private/*/node_modules/.bin
  '';

  buildPhase = ''
    runHook preBuild

    # https://github.com/NixOS/nixpkgs/pull/296697/files#r1617546739
    (
      cd node_modules/.pnpm/node_modules/v-code-diff
      pnpm run postinstall
    )

    # https://github.com/NixOS/nixpkgs/pull/296697/files#r1617595593
    export npm_config_nodedir=${nodejs}
    (
      cd node_modules/.pnpm/node_modules/re2
      pnpm run rebuild --nodedir=${nodejs}
    )

    # Force sass-embedded npm package to use our dart-sass instead of bundled binaries.
    substituteInPlace node_modules/.pnpm/sass-embedded@*/node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

    pnpm build

    runHook postBuild
  '';

  installPhase =
    let
      checkEnvVarScript = writeShellScript "misskey-check-env-var" ''
        if [[ -z $MISSKEY_CONFIG_YML ]]; then
          echo "MISSKEY_CONFIG_YML must be set to the location of the Misskey config file."
          exit 1
        fi
      '';
    in
    # bash
    ''
      runHook preInstall

      mkdir -p $out/data
      sed -i '/"packageManager":/d' package.json
      cp -r . $out/data

      # Set up symlink for use at runtime
      # TODO: Find a better solution for this (potentially patch Misskey to make this configurable?)
      # Line that would need to be patched: https://github.com/misskey-dev/misskey/blob/9849aab40283cbde2184e74d4795aec8ef8ccba3/packages/backend/src/core/InternalStorageService.ts#L18
      # Otherwise, maybe somehow bindmount a writable directory into <package>/data/files.
      ln -s /var/lib/misskey $out/data/files

      makeWrapper ${pnpm}/bin/pnpm $out/bin/misskey \
        --run "${checkEnvVarScript} || exit" \
        --chdir $out/data \
        --add-flag "--config.store-dir=/tmp/pnpm-store" \
        --add-flag "--config.verify-deps-before-run=false" \
        --add-flag run \
        --set-default NODE_ENV production \
        --prefix PATH : ${
          lib.makeBinPath [
            nodejs
            pnpm
            bash
          ]
        } \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            jemalloc
            ffmpeg-headless
            stdenv.cc.cc
          ]
        }

      runHook postInstall
    '';

  passthru = {
    tests.misskey = nixosTests.misskey;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^([0-9.]+)$"
      ];
    };
  };

  meta = {
    description = "Open source, federated social media platform";
    homepage = "https://misskey-hub.net/";
    changelog = "https://github.com/misskey-dev/misskey/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.feathecutie ];
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.unix;
    mainProgram = "misskey";
  };
})
