{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  openssl,
  perl,
  pkg-config,
  protobuf,

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
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "restatedev";
    repo = "restate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uDNPIL9Ox5rwWVzqWe74elHPGy6lSvWR1S7HsY6ATjc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-z7VAKU4bi6pX2z4jCKWDfQt8FFLN7ugnW2LOy6IHz/w=";

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
            "-C debug-assertions"
            "--cfg uuid_unstable"
            "--cfg tokio_unstable"
          ];

          "aarch64-unknown-linux-gnu" = self.build ++ [
            # Enable frame pointers to support Parca (https://github.com/parca-dev/parca-agent/pull/1805)
            "-C force-frame-pointers=yes"
          ];

          "x86_64-unknown-linux-musl" = self.build ++ [
            "-C link-self-contained=yes"
          ];

          "aarch64-unknown-linux-musl" = self.build ++ [
            # Enable frame pointers to support Parca (https://github.com/parca-dev/parca-agent/pull/1805)
            "-C force-frame-pointers=yes"
            "-C link-self-contained=yes"
          ];
        });
      in
      lib.concatStringsSep " " (lib.attrsets.attrByPath [ target ] targetFlags.build targetFlags);

    # Have to be set to dynamically link librdkafka
    CARGO_FEATURE_DYNAMIC_LINKING = 1;
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

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
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
    description = "Restate is a platform for developing distributed fault-tolerant applications.";
    homepage = "https://restate.dev";
    changelog = "https://github.com/restatedev/restate/releases/tag/v${finalAttrs.version}";
    mainProgram = "restate";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [ myypo ];
  };
})
