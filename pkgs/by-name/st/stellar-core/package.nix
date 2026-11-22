{
  autoconf,
  automake,
  bison,
  cargo,
  fetchFromGitHub,
  fetchpatch2,
  flex,
  gitMinimal,
  lib,
  libpq,
  libtool,
  libunwind,
  perl,
  pkg-config,
  runCommand,
  rustc,
  rustPlatform,
  stdenv,
}:

let
  cxxbridge-cmd = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "cxxbridge-cmd";
    version = "1.0.97";

    src = fetchFromGitHub {
      owner = "dtolnay";
      repo = "cxx";
      tag = finalAttrs.version;
      hash = "sha256-Zvu+OYCfBZVQZCNoOG2bDFsz48NnbVH0q4q+CPth+0E=";
    };

    cargoLock.lockFile = ./Cargo.lock;

    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
    '';

    cargoBuildFlags = [
      "--package"
      "cxxbridge-cmd"
    ];

    meta.mainProgram = "cxxbridge";
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "stellar-core";
  version = "30.0.0";

  src = fetchFromGitHub {
    owner = "stellar";
    repo = "stellar-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yVaZVjCR/jm7dm4ldjicUSq4nOheVY3WepjViAbjPMY=";
    fetchSubmodules = true;
  };

  cargoDeps =
    let
      sorobanProtocolHashes = {
        p21 = "sha256-cUhi2YennW+tukwf0woP69bqf1ZMsQ4JDeNqpk0jYjg=";
        p22 = "sha256-5mNAblS3TYXu5a1ThmIdbKC9hUg/3F8vUPvFex3G58U=";
        p23 = "sha256-l1nqc4qrqWV8aKOd9NFUaOLw1Mags2znjbQixU5H3+Y=";
        p24 = "sha256-P+Q8SNcuFX6diBYqGpkOwHtplK4y4PZxB+gj6MnpYDs=";
        p25 = "sha256-9NhnB3bDQI1FLmr0zTYTjEYl8V8KteWbMefWObLDB/A=";
        p26 = "sha256-OxkiWTzNtmYxB64OtLUwghAkcT//SnMZVfUXynFg2Bg=";
        p27 = "sha256-KcsyPBJLUOwRAtp95IYFiZZNMi1xWmYW7XXG+bMucmY=";
        p28 = "sha256-SGA69mE0VZSumZKOBcZqvzYtZRkFVSIMHFI5R9xcTWE=";
        p29 = "sha256-O3WVmx0Ty04eOF6txTSYIj3VLxJS7BFDCYH54mAKtVY=";
        p30 = "sha256-KoBgiIiZSR3E198ScGG1wekodabNWNKHi/1MgNWdw9w=";
      };
      mainCargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src;
        hash = "sha256-B3UhPnfND9b1r6mOy2QydPFUky0l5BSj6v88gx3TNIw=";
      };
      sorobanCargoDeps = lib.mapAttrs (
        protocol: hash:
        rustPlatform.fetchCargoVendor {
          pname = "stellar-core-${protocol}";
          inherit (finalAttrs) version src;
          cargoRoot = "src/rust/soroban/${protocol}";
          inherit hash;
        }
      ) sorobanProtocolHashes;
    in
    # Every lockfile is built from one `.cargo/config.toml` at the source root.
    # fetchCargoVendor numbers git sources per lockfile (NixOS/nixpkgs#387337),
    # so a `symlinkJoin` of the vendor directories drops all but the first
    # config and lets protocols that pin different revisions of one repository
    # overwrite each other. Merge the directories by git revision instead.
    runCommand "stellar-core-${finalAttrs.version}-cargo-vendor-dir"
      {
        vendors = [ mainCargoDeps ] ++ lib.attrValues sorobanCargoDeps;
        passthru = {
          inherit sorobanProtocolHashes mainCargoDeps sorobanCargoDeps;
        };
      }
      ''
        mergeSource() {
          if [ ! -d "$out/source-$1" ]; then
            mkdir "$out/source-$1"
            printf '%s\n' "[source.$1]" "''${@:3}" "replace-with = \"vendored-$1\"" \
              "[source.vendored-$1]" "directory = \"@vendor@/source-$1\""
          fi
          ln -sfn -t "$out/source-$1" "$2"/*
        }

        mkdir -p "$out"/.cargo
        ln -s ${mainCargoDeps}/Cargo.lock "$out"/Cargo.lock
        for vendor in $vendors; do
          mergeSource crates-io "$vendor/source-registry-0"
          while read -r dir url rev; do
            mergeSource "git-$rev" "$vendor/$dir" "git = \"$url\"" "rev = \"$rev\""
          done < <(awk -F'"' '
            /^\[source\.original-/ { dir = $0; gsub(/.*original-|\]/, "", dir) }
            /^git = / { url = $2 }
            /^rev = / { print dir, url, $2 }
          ' "$vendor"/.cargo/config.toml)
        done > "$out"/.cargo/config.toml

        # `soroban-synth-wasm` resolves this path relative to the vendored git
        # source root, but cargo vendors the workspace crates with versioned
        # directory names.
        for source in "$out"/source-git-*; do
          for dir in "$source"/soroban-env-common-*; do
            if [ -d "$dir" ] && [ ! -e "$source"/soroban-env-common ]; then
              ln -s "$(basename "$dir")" "$source"/soroban-env-common
            fi
            break
          done
        done
      '';

  postPatch = ''
    # Include integer types explicitly instead of relying on transitive standard
    # library includes, some of which were removed in GCC 16.
    substituteInPlace \
      lib/libmedida/src/medida/stats/snapshot.h \
      src/invariant/test/InvariantTestUtils.h \
      src/util/xdrquery/XDRQueryEval.h \
      --replace-fail '#include <memory>' $'#include <cstdint>\n#include <memory>'
    substituteInPlace src/util/DebugMetaUtils.h \
      --replace-fail '#include <filesystem>' $'#include <cstdint>\n#include <filesystem>'

    # ethnum <= 1.5.2 fails on rustc 1.97+ (TryFromIntError is no longer ZST).
    # Protocols p21-p26 pin ethnum 1.5.0 in Cargo.lock / dep-tree expects, so keep
    # that version and apply the upstream 1.5.3 source fix in the vendored crate.
    # https://github.com/nlordell/ethnum-rs/pull/58
    shopt -s nullglob
    for crate in "$cargoDepsCopy"/source-crates-io/ethnum-1.5.0; do
      patch -p1 -d "$crate" < ${
        fetchpatch2 {
          name = "ethnum-1.5.0-rustc-1.97.patch";
          url = "https://github.com/nlordell/ethnum-rs/commit/87e3457c095c98fcac554548ee80f56e0cfb80ae.patch?full_index=1";
          hash = "sha256-xG3RQg2vF+XW9IiYWaNyOF39WipSeoZGrygsOJ3XgIs=";
        }
      }
    done

    # Git dependencies do not include Cargo's published-crate VCS metadata.
    # Recreate it so crate-git-revision can provide GIT_REVISION.
    for crate in "$cargoDepsCopy"/source-git-*/*/; do
      rev="$(basename "$(dirname "$crate")")"
      printf '{"git":{"sha1":"%s"}}\n' "''${rev#source-git-}" > "$crate/.cargo_vcs_info.json"
    done
  '';

  strictDeps = true;

  nativeBuildInputs = [
    automake
    autoconf
    bison
    cargo
    flex
    gitMinimal
    libtool
    perl
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libpq
    libunwind
  ];

  enableParallelBuilding = true;

  # Build the large Rust crate separately to avoid its peak memory use
  # overlapping with parallel C++ compilation. On aarch64, the release
  # profile's fat LTO and single codegen unit also exceed typical builder limits.
  preBuild =
    lib.optionalString stdenv.hostPlatform.isAarch64 ''
      export CARGO_PROFILE_RELEASE_LTO=off
      export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16
    ''
    + ''
      make -C src -j"$NIX_BUILD_CORES" ../target/release/librust_stellar_core.a
    '';

  doCheck = true;
  # The standalone consensus test binds to localhost.
  __darwinAllowLocalNetworking = true;

  preConfigure = ''
    # Due to https://github.com/NixOS/nixpkgs/issues/8567 we cannot rely on
    # having the .git directory present, so directly provide the version
    substituteInPlace src/Makefile.am --replace '$$vers' 'stellar-core ${finalAttrs.version}';
    substituteInPlace src/Makefile.am \
      --replace-fail 'CARGO=cargo +$(RUST_TOOLCHAIN_CHANNEL)' 'CARGO=cargo' \
      --replace-fail \
        'RUSTC_WRAPPER="$(RUSTC_WRAPPER)" CARGO_HTTP_MULTIPLEXING=false $(CARGO) install --force --locked --root $(RUST_BUILD_DIR) cxxbridge-cmd --version 1.0.68' \
        'install -Dm755 ${lib.getExe cxxbridge-cmd} $(RUST_CXXBRIDGE)' \
      --replace-fail \
        '$(SOROBAN_LIBS_STAMP): $(wildcard rust/soroban/p*/Cargo.lock) $(ALL_SOROBAN_GIT_STATE_STAMPS) Makefile $(RUST_DEP_TREE_STAMP) $(SRC_RUST_FILES) $(RUST_TOOLCHAIN_FILE)' \
        '$(SOROBAN_LIBS_STAMP): $(wildcard rust/soroban/p*/Cargo.lock) Makefile $(RUST_DEP_TREE_STAMP) $(SRC_RUST_FILES) $(RUST_TOOLCHAIN_FILE)'
    patchShebangs hash-xdrs.sh src/test

    # Everything needs to be staged in git because the build uses
    # `git ls-files` to search for source files to compile.
    git init
    git add .

    ./autogen.sh
  '';

  checkPhase = ''
    runHook preCheck

    # The full upstream test suite is too heavy for a default package check.
    # Keep this focused on a basic consensus smoke test.
    ./src/stellar-core test --ll fatal -w NoTests -a -r simple --disable-dots "standalone"

    runHook postCheck
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Reference peer-to-peer agent that manages the Stellar network";
    longDescription = ''
      Stellar-core is a replicated state machine that maintains a local copy of
      the Stellar cryptographic ledger and processes transactions against it in
      consensus with a set of peers. It implements the Stellar Consensus
      Protocol, a federated consensus protocol.
    '';
    homepage = "https://www.stellar.org/";
    changelog = "https://github.com/stellar/stellar-core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "stellar-core";
  };
})
