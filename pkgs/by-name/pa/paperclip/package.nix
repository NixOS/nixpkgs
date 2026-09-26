{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  rustPlatform,
  runCommand,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  makeWrapper,
  python3,
  pkg-config,
  cmake,
  coreutils,
  postgresql,
  vips,
  openssh,
  patchelf,
  procps,
  which,
  curl,
  gh,
  git,
  jq,
  lsof,
  ripgrep,
  wget,
}:
let
  version = "0.3.1-unstable-2026-09-26";
  # Draft packaging source. Replace with a paperclipai release before merging.
  src = fetchFromGitHub {
    owner = "caniko";
    repo = "paperclip";
    rev = "7d4855648ae08dbf8265322969fcf707a9b9090a";
    hash = "sha256-s0v1FvyQ0sFZ9Ua/1qFr3CGGS6EQLKuSa+z7kAh5aco=";
  };
  runtimePath = lib.makeBinPath [
    curl
    gh
    git
    jq
    lsof
    openssh
    postgresql
    procps
    ripgrep
    wget
  ];
  runner = rustPlatform.buildRustPackage {
    pname = "paperclip-runnerd";
    inherit version;
    src = "${src}/packages/paperclip-runner";
    cargoRoot = "runner";
    buildAndTestSubdir = "runner";
    cargoLock.lockFile = "${src}/packages/paperclip-runner/runner/Cargo.lock";
    cargoBuildFlags = [ "--bin=paperclip-runnerd" ];
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    nativeCheckInputs = [
      procps
      which
    ];
    postPatch = ''
      substituteInPlace runner/crates/runner-core/src/codex_provider.rs \
        --replace-fail '"/bin/cat"' '"${coreutils}/bin/cat"'
      substituteInPlace runner/crates/runner-core/tests/codex_provider.rs \
        --replace-fail '"/bin/kill"' '"${procps}/bin/kill"'
      substituteInPlace runner/crates/runner-core/tests/process_supervisor.rs \
        --replace-fail '"/usr/bin/which"' '"${which}/bin/which"'
      substituteInPlace runner/crates/runner-core/src/process_supervisor.rs \
        --replace-fail 'Command::new("kill")' 'Command::new("${procps}/bin/kill")'
    '';
  };
  unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "paperclip";
    inherit version src;
    strictDeps = true;
    nativeBuildInputs = [
      nodejs
      pnpm_10
      pnpmConfigHook
      makeWrapper
      python3
      pkg-config
    ];
    buildInputs = [
      postgresql
      vips
    ];
    postPatch = ''
      substituteInPlace server/src/services/railway-ssh.ts \
        --replace-fail '"/usr/bin/ssh-keygen"' '"${openssh}/bin/ssh-keygen"' \
        --replace-fail '"/usr/bin/ssh"' '"${openssh}/bin/ssh"'
    '';
    pnpmInstallFlags = [ "--shamefully-hoist" ];
    pnpmWorkspaces = [
      "paperclipai..."
      "@paperclipai/ui..."
    ];
    prePnpmInstall = ''
      pnpm config set network-concurrency 4
      pnpm config set fetch-retries 5
      pnpm config set fetch-retry-mintimeout 20000
      pnpm config set fetch-retry-maxtimeout 120000
      pnpm config set fetch-timeout 600000
      ${nodejs}/bin/node scripts/nix-pnpm-patch-hashes.mjs
    '';
    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        pnpmWorkspaces
        prePnpmInstall
        ;
      pnpm = pnpm_10;
      fetcherVersion = 4;
      hash = "sha256-e2PGbttFzg89GKuJOdO0F+VcVu6wYFevs1UI/E8M+2g=";
    };
    buildPhase = ''
      runHook preBuild
      pnpm --filter @paperclipai/paperclip-runner build:typescript
      mkdir -p packages/paperclip-runner/dist/bin
      cp ${runner}/bin/paperclip-runnerd packages/paperclip-runner/dist/bin/
      ${nodejs}/bin/node --input-type=module -e '
        import fs from "node:fs";
        const file = "server/package.json";
        const manifest = JSON.parse(fs.readFileSync(file));
        manifest.scripts["prepare:runner-vendor"] = "pnpm --filter @paperclipai/paperclip-runner build:typescript";
        fs.writeFileSync(file, JSON.stringify(manifest));
      '
      pnpm --filter @paperclipai/ui build
      pnpm --filter @paperclipai/plugin-sdk build
      NODE_OPTIONS=--max-old-space-size=4096 pnpm --filter @paperclipai/server build
      pnpm --filter paperclipai build
      test -f server/dist/index.js
      test -f cli/dist/index.js
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/lib/paperclip" "$out/bin"
      cp -R . "$out/lib/paperclip"
      makeWrapper ${nodejs}/bin/node "$out/bin/paperclip" \
        --add-flags "$out/lib/paperclip/cli/dist/index.js" \
        --set-default NODE_ENV production \
        --set-default PAPERCLIP_BUILD_VERSION ${lib.escapeShellArg version} \
        --prefix PATH : ${lib.escapeShellArg runtimePath}
      makeWrapper ${nodejs}/bin/node "$out/bin/paperclip-server" \
        --add-flags "--import $out/lib/paperclip/server/node_modules/tsx/dist/loader.mjs" \
        --add-flags "$out/lib/paperclip/server/dist/index.js" \
        --set-default NODE_ENV production \
        --set-default PAPERCLIP_BUILD_VERSION ${lib.escapeShellArg version} \
        --set-default SERVE_UI true \
        --set-default HOST 127.0.0.1 \
        --set-default PORT 3100 \
        --prefix PATH : ${lib.escapeShellArg runtimePath}
      runHook postInstall
    '';
    meta = {
      description = "Control plane for autonomous AI companies";
      homepage = "https://github.com/paperclipai/paperclip";
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.caniko ];
      mainProgram = "paperclip";
      platforms = [ "x86_64-linux" ];
    };
  });
  # Embedded PostgreSQL binaries use an FHS interpreter and look for unversioned
  # sonames. Repair the immutable bundle before exposing it as a service package.
  runtime =
    runCommand "paperclip-${version}"
      {
        pname = "paperclip";
        inherit version;
        inherit (unwrapped) meta;
        passthru.unwrapped = unwrapped;
        dontFixup = true;
      }
      ''
        cp -a --reflink=auto ${unwrapped} "$out"
        chmod u+w "$out/bin/paperclip" "$out/bin/paperclip-server"
        substituteInPlace "$out/bin/paperclip" "$out/bin/paperclip-server" \
          --replace-fail ${unwrapped} "$out"

        while IFS= read -r -d "" executable; do
          if ${patchelf}/bin/patchelf --print-interpreter "$executable" >/dev/null 2>&1; then
            chmod u+w "$executable"
            ${patchelf}/bin/patchelf --set-interpreter ${lib.escapeShellArg stdenv.cc.bintools.dynamicLinker} "$executable"
          fi
        done < <(find "$out/lib/paperclip/node_modules/.pnpm" \
          -path '*/@embedded-postgres/*/native/bin/*' -type f -print0)

        while IFS= read -r -d "" library; do
          libDir="$(dirname "$library")"
          libraryName="$(basename "$library")"
          aliasName="$(printf '%s\n' "$libraryName" | sed -E 's/^(lib.+\.so\.[0-9]+)\.[0-9]+(\.[0-9]+)?$/\1/')"
          if [ "$aliasName" = "$libraryName" ] || [ -e "$libDir/$aliasName" ]; then
            continue
          fi
          chmod u+w "$libDir"
          ln -s "$libraryName" "$libDir/$aliasName"
          chmod u-w "$libDir"
        done < <(find "$out/lib/paperclip/node_modules/.pnpm" \
          -path '*/@embedded-postgres/*/native/lib/lib*.so.*.*' -type f -print0)
      '';
in
runCommand "paperclip-${version}"
  {
    pname = "paperclip";
    inherit version;
    inherit (runtime) meta;
    nativeBuildInputs = [ makeWrapper ];
    passthru = {
      inherit runtime unwrapped;
      runnerd = runner;
    };
  }
  ''
    mkdir -p "$out/bin"
    ln -s ${runtime}/lib "$out/lib"
    makeWrapper ${runtime}/bin/paperclip "$out/bin/paperclip" \
      --prefix PATH : ${lib.escapeShellArg (lib.makeBinPath [ nodejs ])}
    makeWrapper ${runtime}/bin/paperclip-server "$out/bin/paperclip-server" \
      --prefix PATH : ${lib.escapeShellArg (lib.makeBinPath [ nodejs ])} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}
    makeWrapper ${nodejs}/bin/node "$out/bin/paperclip-deployment" \
      --add-flags "--import ${runtime}/lib/paperclip/server/node_modules/tsx/dist/loader.mjs" \
      --add-flags "${runtime}/lib/paperclip/server/dist/deployment-entry.js" \
      --prefix PATH : ${lib.escapeShellArg "${lib.makeBinPath [ nodejs ]}:${runtimePath}"} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}
  ''
