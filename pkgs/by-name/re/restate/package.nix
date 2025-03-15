{
  lib,
  stdenv,
  testers,
  versionCheckHook,
  nix-update-script,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  restate,
  pkg-config,
  openssl,
  perl,
  cmake,
  cacert,
  rdkafka,
}:
rustPlatform.buildRustPackage rec {
  pname = "restate";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "restatedev";
    repo = "restate";
    tag = "v${version}";
    hash = "sha256-igvwwVOtlCREWr8WIjF0jVY0NCQDFc8/CRc3kRSPtAM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tduXsd4nXud296i6LDkNRjiFnzPb9OQElLxYvNk37Qw=";

  env = {
    PROTOC = lib.getExe protobuf;
    PROTOC_INCLUDE = "${protobuf}/include";

    VERGEN_GIT_COMMIT_DATE = "2025-03-12";
    VERGEN_GIT_SHA = "v${version}";

    # rustflags as defined in the upstream's .cargo/config.toml
    RUSTFLAGS =
      let
        target = stdenv.hostPlatform.config;
        targetFlags = rec {
          build = [
            "-C force-unwind-tables"
            "--cfg uuid_unstable"
            "--cfg tokio_unstable"
          ];

          "aarch64-unknown-linux-gnu" = build ++ [
            # Enable frame pointers to support Parca (https://github.com/parca-dev/parca-agent/pull/1805)
            "-C force-frame-pointers=yes"
          ];

          "x86_64-unknown-linux-musl" = build ++ [
            "-C link-self-contained=yes"
          ];

          "aarch64-unknown-linux-musl" = build ++ [
            # Enable frame pointers to support Parca (https://github.com/parca-dev/parca-agent/pull/1805)
            "-C force-frame-pointers=yes"
            "-C link-self-contained=yes"
          ];
        };
      in
      lib.concatStringsSep " " (lib.attrsets.attrByPath [ target ] targetFlags.build targetFlags);

    # Have to be set to dynamically link librdkafka
    CARGO_FEATURE_DYNAMIC_LINKING = 1;
  };

  nativeBuildInputs = [
    pkg-config
    openssl
    perl
    rustPlatform.bindgenHook
    cmake
  ];
  buildInputs = [ rdkafka ];
  nativeCheckInputs = [
    cacert
  ];

  useNextest = true;
  # Feature resolution seems to be failing due to this https://github.com/rust-lang/cargo/issues/7754
  auditable = false;

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  checkFlags = [
    "--skip replicated_loglet"
    "--skip fast_forward_over_trim_gap"
  ];

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
    description = "Restate is a platform for developing distributed fault-tolerant applications.";
    homepage = "https://restate.dev";
    changelog = "https://github.com/restatedev/restate/releases/tag/v${version}";
    mainProgram = "restate";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [ myypo ];
  };
}
