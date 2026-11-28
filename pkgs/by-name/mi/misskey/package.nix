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
  version = "2026.10.1";

  src = fetchFromGitHub {
    owner = "misskey-dev";
    repo = "misskey";
    tag = finalAttrs.version;
    hash = "sha256-6N2YUs/iw4KCBM8ltjjwxTMJTstNXxNbXWQeZQPUXG0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Misskey converts its YAML config to JSON at runtime, which doesn't work
    # because it tries to write it to the Nix store. As a workaround, hardcode
    # this to a path which the service can write to until a better solution is
    # supported, upstream.
    # https://github.com/misskey-dev/misskey/issues/17075
    substituteInPlace packages/backend/src/config.ts \
      --replace-fail \
        "resolve(projectBuiltDir, '.config.json')" \
        "resolve('/run/misskey/default.json')"
    substituteInPlace {.,packages/backend}/package.json \
      --replace-fail "pnpm compile-config && " ""

    # Misskey complains about nodejs version being too old https://github.com/misskey-dev/misskey/blob/14554ff2b49d9b1a26d9a1444e783f08eaa29444/packages/backend/package.json#L7
    substituteInPlace pnpm-workspace.yaml \
      --replace-fail 'engineStrict: true' 'engineStrict: false'
  '';

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
      postPatch
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-mZ4fnibh35jpUfR9w+yP6Zg7LQTmDxDqCNQzOXz7Ph0=";
  };

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
