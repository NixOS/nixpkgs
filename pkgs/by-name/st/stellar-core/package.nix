{
  autoconf,
  automake,
  bison,
  fetchFromGitHub,
  flex,
  gitMinimal,
  lib,
  libpq,
  libtool,
  libunwind,
  perl,
  pkg-config,
  ripgrep,
  rustc,
  rustPlatform,
  stdenv,
  symlinkJoin,
  cargo,
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
  version = "27.0.0";

  src = fetchFromGitHub {
    owner = "stellar";
    repo = "stellar-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ikTkp/r24xTJ+RDMlu5q8PmFvGUeLz/sejeIjOSmd5M=";
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
      };
    in
    symlinkJoin {
      name = "stellar-core-${finalAttrs.version}-cargo-vendor-dir";
      paths = [
        (rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) src;
          hash = "sha256-e7WGYm5RLmg9vjcMjy98RBW0QqjGTd8cPPeilhYbZ2I=";
        })
      ]
      ++ lib.mapAttrsToList (
        protocol: hash:
        rustPlatform.fetchCargoVendor {
          pname = "stellar-core-${protocol}";
          inherit (finalAttrs) version src;
          cargoRoot = "src/rust/soroban/${protocol}";
          inherit hash;
        }
      ) sorobanProtocolHashes;
      postBuild = ''
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
    };

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
    ripgrep
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libpq
    libunwind
  ];

  enableParallelBuilding = true;

  doCheck = true;

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
