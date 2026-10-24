{
  buzz-cli,
  lib,
  jq,
  nak,
  nixosTests,
  runCommand,
  rustPlatform,
  stdenv,
  cmake,
  pkg-config,
  perl,
  protobuf,
  openssl,
  bashNonInteractive,
  gitMinimal,
  makeBinaryWrapper,
  stdenvNoCC,
  fetchPnpmDeps,
  fetchpatch2,
  nodejs_24,
  pnpm_11,
  pnpmConfigHook,
}:

# Updated together with buzz-cli by its update.sh (same source and cargoHash).
# nixpkgs-update: no auto update
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-relay";
  # The relay is released on its own (relay-vX.Y.Z tags), but the last release
  # predates features the current desktop relies on, so this builds the same
  # Buzz release as buzz-cli: an unreleased relay, named after the relay's
  # crate version (checked in postPatch) and the date of that release.
  version = "0.2.1-unstable-2026-10-09";
  # Shares the Buzz workspace source and Cargo lockfile with buzz-cli.
  inherit (buzz-cli)
    src
    cargoHash
    preBuild
    ;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    protobuf
    makeBinaryWrapper
  ];

  buildInputs = [ openssl ];

  patches = [
    # BUZZ_HEALTH_BIND_ADDR and BUZZ_METRICS_BIND_ADDR: the health and metrics
    # listeners otherwise always bind 0.0.0.0. The module binds them to listenAddress.
    # https://github.com/block/buzz/pull/8004
    (fetchpatch2 {
      name = "relay-configurable-health-metrics-bind.patch";
      url = "https://github.com/block/buzz/compare/c96d707f6efd359e6cfdc34bd93c8b5fb36f1d5d..1c840b38d4eec0b6f42036b73ea12881754875fb.diff?full_index=1";
      includes = [ "crates/buzz-relay/src/*" ];
      hash = "sha256-w4VE7mETweJHZ9nJr7arMQeZv42j2L4dM85a22k61x8=";
    })
  ];

  postPatch = buzz-cli.postPatch + ''
    grep -qx 'version = "${lib.head (lib.splitString "-" finalAttrs.version)}"' crates/buzz-relay/Cargo.toml \
      || { echo "buzz-relay crate version changed; update version" >&2; exit 1; }

    # The generated git hook runs under /usr/bin/env bash, which the service
    # environment doesn't have. https://github.com/block/buzz/pull/8071 makes
    # the interpreter configurable (BUZZ_BASH_PATH).
    substituteInPlace crates/buzz-relay/src/api/git/hook.rs \
      --replace-fail '#!/usr/bin/env bash' '#!${lib.getExe bashNonInteractive}'
  '';

  # cmake is only used by dependency build scripts; avoid overriding cargo configurePhase
  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package=buzz-relay"
    "--package=buzz-admin"
    "--package=buzz-pair-relay"
  ];

  # Full workspace tests require live Postgres, Redis, and S3 services
  doCheck = false;

  # Like upstream's container image: the relay serves the invite landing page
  # from the web bundle, and the admin dashboard once BUZZ_ADMIN_HOST is set.
  postInstall = ''
    wrapProgram $out/bin/buzz-relay \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
          bashNonInteractive
        ]
      } \
      --set-default BUZZ_WEB_DIR ${finalAttrs.passthru.web}/web \
      --set-default BUZZ_ADMIN_WEB_DIR ${finalAttrs.passthru.web}/admin-web
  '';

  # The web UI and admin dashboard, built from the same workspace.
  passthru.web = stdenvNoCC.mkDerivation (webAttrs: {
    pname = "buzz-relay-web";
    inherit (finalAttrs) version src;

    pnpmWorkspaces = [
      "buzz-web"
      "buzz-admin-web"
    ];
    pnpmDeps = fetchPnpmDeps {
      inherit (webAttrs)
        pname
        version
        src
        pnpmWorkspaces
        ;
      # Upstream's package.json pins pnpm 11 (`packageManager`).
      pnpm = pnpm_11;
      fetcherVersion = 5;
      hash = "sha256-OEC0AZJE4RIV0XFcwQE1lF5WTytyDIcezNVSPxOmmg8=";
    };

    nativeBuildInputs = [
      nodejs_24
      pnpm_11
      pnpmConfigHook
    ];

    buildPhase = ''
      runHook preBuild
      pnpm -C web build
      pnpm -C admin-web build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r web/dist $out/web
      cp -r admin-web/dist $out/admin-web
      runHook postInstall
    '';

    meta = {
      description = "Web UI and admin dashboard served by buzz-relay";
      inherit (finalAttrs.meta) homepage license maintainers;
      platforms = lib.platforms.all;
    };
  });

  passthru.tests = {
    # buzz-pair-relay: an encrypted NIP-AB pairing event (kind 24134) must reach a
    # `#p` subscriber intact, and a tampered signature must be rejected.
    pair-relay =
      runCommand "buzz-pair-relay-roundtrip"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            jq
            nak
          ];
          # The relay and the subscriber talk over loopback.
          __darwinAllowLocalNetworking = true;
        }
        ''
          export HOME=$TMPDIR
          # Test-only keys (secret keys 1 and 2).
          a=0000000000000000000000000000000000000000000000000000000000000001
          b=0000000000000000000000000000000000000000000000000000000000000002
          pa=$(nak key public $a)
          pb=$(nak key public $b)
          url=ws://127.0.0.1:5000
          wait_for() { for _ in $(seq 100); do "$@" && return; sleep 0.1; done; "$@"; }

          # Stop the relay and the subscriber when the script ends: a process
          # that outlives it keeps the build log open, and on darwin nothing
          # else ends the build.
          trap 'kill $(jobs -p) 2> /dev/null' EXIT
          BUZZ_PAIR_RELAY_BIND_ADDR=127.0.0.1:5000 buzz-pair-relay > relay.log 2>&1 &
          wait_for grep -q listening relay.log

          timeout 30 nak req --stream -k 24134 -p "$pb" "$url" > received.jsonl 2> subscriber.log &
          wait_for grep -q ok subscriber.log

          ciphertext=$(nak encrypt --sec $a -p "$pb" pairing-test | tail -n 1)
          nak event -k 24134 -p "$pb" -c "$ciphertext" --sec $a "$url"
          wait_for test -s received.jsonl
          received=$(jq -r .content received.jsonl | head -n 1)
          test "$(nak decrypt --sec $b -p "$pa" "$received" | tail -n 1)" = pairing-test

          tampered=$(nak event -k 24134 -p "$pb" -c "$ciphertext" --sec $a | jq -c '.sig = ("00" + .sig[2:])')
          if result=$(echo "$tampered" | nak event "$url" 2>&1); then
            echo "relay accepted a tampered event: $result" >&2
            exit 1
          fi
          grep -q 'signature verification failed' <<< "$result"

          touch $out
        '';
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    nixos = nixosTests.buzz-relay;
  };

  meta = {
    description = "Relay server, admin CLI, and pairing relay for the Buzz decentralized workspace";
    homepage = "https://github.com/block/buzz";
    changelog = "https://github.com/block/buzz/blob/${finalAttrs.src.tag}/crates/buzz-relay/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "buzz-relay";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
