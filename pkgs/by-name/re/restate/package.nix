{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  protobuf,

  # nativeBuildInputs
  cmake,
  openssl,
  perl,
  pkg-config,

  # buildInputs
  rdkafka,

  # tests
  cacert,
  versionCheckHook,

  # passthru
  testers,
  restate,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "restate";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "restatedev";
    repo = "restate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i9P6Lh0Qw4ylUVwAE51UTE5rSDluZafpEmxuAtv0SYQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "base62-2.2.3" = "sha256-K5ymIrMbMyHKYHs6p45akRI4Ec+k1gV9ZgqC0aJ9iSc=";
      "raft-0.7.0" = "sha256-r/p+ebxczUDzLqMcxc8l/IAuvjmI058UOF1UHE57oVA=";
      "rdkafka-0.38.0" = "sha256-JNGW57chwpcwnF8owcG1hP3MZ5Bunz6GDI3ro/2DUH0=";
      "restate-web-ui-0.1.49" = "sha256-RNzt4gcwWhx5gP9n4UxqkmUL2097BG1ZTflYLiWJQTs=";
      "rust-librocksdb-sys-0.41.0+10.9.1" = "sha256-WixwYhtj6SgrhRs+H/1RXQpzbaTbToRbAWmi26dA7g8=";
      "sasl2-sys-0.1.22+2.1.28" = "sha256-rzqbNXiJp9h0gQZhbp+yfbaiFeotuz2tX00vHOO34jQ=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  env = {
    PROTOC = lib.getExe protobuf;
    PROTOC_INCLUDE = "${protobuf}/include";

    VERGEN_GIT_SHA = "v${finalAttrs.version}";

    # rustflags as defined in the upstream's .cargo/config.toml
    RUSTFLAGS =
      let
        target = stdenv.hostPlatform.config;
        targetFlags = lib.fix (self: {
          build = [
            "-C force-unwind-tables"
            "--cfg uuid_unstable"
            "--cfg tokio_unstable"
          ];

          "aarch64-unknown-linux-gnu" = self.build ++ [
            # Enable frame pointers to support Parca (https://github.com/parca-dev/parca-agent/pull/1805)
            "-C force-frame-pointers=yes"
            "--cfg tokio_taskdump"
          ];

          "x86_64-unknown-linux-musl" = self.build ++ [
            "-C link-self-contained=yes"
            "--cfg tokio_taskdump"
          ];

          "aarch64-unknown-linux-musl" = self.build ++ [
            # Enable frame pointers to support Parca (https://github.com/parca-dev/parca-agent/pull/1805)
            "-C force-frame-pointers=yes"
            "-C link-self-contained=yes"
            "--cfg tokio_taskdump"
          ];
        });
      in
      lib.concatStringsSep " " (lib.attrsets.attrByPath [ target ] targetFlags.build targetFlags);

    # Have to be set to dynamically link librdkafka
    CARGO_FEATURE_DYNAMIC_LINKING = 1;

    # krb5-src contains K&R-style C code incompatible with GCC 14's default C23 standard;
    # tikv-jemalloc-sys has a strerror_r return type mismatch (-Wint-conversion)
    NIX_CFLAGS_COMPILE = "-std=gnu17 -Wno-error=int-conversion";
  };

  nativeBuildInputs = [
    cmake
    openssl
    perl
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    rdkafka
  ];

  nativeCheckInputs = [
    cacert
  ];

  useNextest = true;
  # Feature resolution seems to be failing due to this https://github.com/rust-lang/cargo/issues/7754
  auditable = false;

  checkFlags = [
    # Error: deadline has elapsed
    "--skip"
    "replicated_loglet"
    # TIMEOUT [ 180.006s]
    "--skip"
    "fast_forward_over_trim_gap"
    # TIMEOUT (could be related to https://github.com/restatedev/restate/issues/3043)
    "--skip"
    "restatectl_smoke_test"
  ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    tests.restateCliVersion = testers.testVersion {
      package = restate;
      command = "restate --version";
    };
    tests.restateServerVersion = testers.testVersion {
      package = restate;
      command = "restate-server --version";
    };
    tests.restateCtlVersion = testers.testVersion {
      package = restate;
      command = "restatectl --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Platform for developing distributed fault-tolerant applications";
    homepage = "https://restate.dev";
    changelog = "https://github.com/restatedev/restate/releases/tag/v${finalAttrs.version}";
    mainProgram = "restate";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [ myypo ];
  };
})
