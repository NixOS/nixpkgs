{
  lib,
  fetchCrate,
  rustPlatform,
  openssl,
  pkg-config,
  makeWrapper,
  coreutils,
  nix-update-script,
  versionCheckHook,
  # `DEFAULT_PLATFORM_TOOLS_VERSION`;
  # https://github.com/anza-xyz/cargo-build-sbf/blob/master/cargo-build-sbf/src/toolchain.rs
  solana-platform-tools_154,
  solana-platform-tools_157,
}:

let
  mkCargoBuildSbf =
    {
      version,
      hash,
      cargoHash,
      platformTools,
    }:
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "cargo-build-sbf";
      inherit version;

      src = fetchCrate {
        pname = "cargo-build-sbf";
        inherit version;
        inherit hash;
      };

      inherit cargoHash;

      __structuredAttrs = true;
      strictDeps = true;

      nativeBuildInputs = [
        pkg-config
        makeWrapper
      ];

      buildInputs = [
        openssl
        platformTools
      ];

      env.OPENSSL_NO_VENDOR = 1;

      # tests/crates.rs drives the built binary end-to-end: it force-downloads
      # platform-tools (`--force-tools-install`), then compiles SBF programs from
      # `tests/crates/`. That needs network access and writes to a user cache.
      doCheck = false;

      doInstallCheck = true;
      nativeInstallCheckInputs = [ versionCheckHook ];
      versionCheckProgram = "${placeholder "out"}/bin/cargo-build-sbf";

      postFixup = ''
        for bin in cargo-build-sbf cargo-test-sbf; do
          wrapProgram $out/bin/$bin \
            --prefix PATH : "${lib.makeBinPath [ coreutils ]}:${platformTools}/rust/bin" \
            --set RUSTC "${platformTools}/rust/bin/rustc" \
            --run 'args=("$@")
            # cargo passes the subcommand name as argv[1] (`cargo build-sbf ...`
            # arrives as `build-sbf ...`). Upstream strips it too, but only after
            # this wrapper runs, so strip it here first: the flag scan below needs
            # to see the real flags.
            if [ "''${args[0]-}" = build-sbf ]; then args=("''${args[@]:1}"); fi
            if [ "''${args[0]-}" = test-sbf ]; then args=("''${args[@]:1}"); fi
            # Use the toolchain from the store instead of rustup, unless the user
            # already passed the flag or asked for a fresh download
            # (--force-tools-install conflicts with it; clap rejects duplicates).
            have() { local a; for a in "''${args[@]}"; do [ "$a" = "$1" ] && return 0; done; return 1; }
            if ! have --no-rustup-override && ! have --force-tools-install; then
              args=(--no-rustup-override "''${args[@]}")
            fi
            set -- "''${args[@]}"
            # Upstream exits when HOME is unset; hand it a temporary one. It cannot
            # be removed once the binary is exec()ed, so rely on $TMPDIR cleanup.
            if [ -z "''${HOME-}" ]; then HOME="$(mktemp -d)"; export HOME; fi
            # Point upstream at the store toolchain; install_if_missing() accepts a
            # symlink and then skips its download.
            cache="$HOME/.cache/solana/v${platformTools.version}"
            mkdir -p "$cache"
            [ -e "$cache/platform-tools/rust/bin/rustc" ] || \
              ln -sfn "${platformTools}" "$cache/platform-tools"'
        done
      '';

      meta = {
        description = "Compile Solana programs using the Solana SBF SDK";
        homepage = "https://github.com/anza-xyz/cargo-build-sbf";
        changelog = "https://github.com/anza-xyz/cargo-build-sbf/releases";
        license = lib.licenses.asl20;
        mainProgram = "cargo-build-sbf";
        maintainers = with lib.maintainers; [ _0xgsvs ];
        platforms = lib.platforms.unix;
      };

      passthru.updateScript = nix-update-script { };
    });
in
{
  cargo-build-sbf_41 = mkCargoBuildSbf {
    version = "4.1.0";
    hash = "sha256-tfmsjOixus0JhAQ7XjqYwzgqB4U9FxZL3u89kKu5TWI=";
    cargoHash = "sha256-TCur1rDsfx4j4VtJIVhSBkXR6UyADJ3JXhdHFuT5h8U=";
    platformTools = solana-platform-tools_154;
  };

  cargo-build-sbf_44 = mkCargoBuildSbf {
    version = "4.4.0";
    hash = "sha256-CDOn/MJAih6+1wPnBV112CVN4r2ALGMBUq7ZKjJld0g=";
    cargoHash = "sha256-QTbQr81KOSePrSvwPtVHXmSwOlCDRusqBVbuTOlWk9g=";
    platformTools = solana-platform-tools_157;
  };

  cargo-build-sbf_latest = mkCargoBuildSbf {
    version = "4.4.0";
    hash = "sha256-CDOn/MJAih6+1wPnBV112CVN4r2ALGMBUq7ZKjJld0g=";
    cargoHash = "sha256-QTbQr81KOSePrSvwPtVHXmSwOlCDRusqBVbuTOlWk9g=";
    platformTools = solana-platform-tools_157;
  };
}
