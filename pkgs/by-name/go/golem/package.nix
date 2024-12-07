{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  pkg-config,
  protobuf,

  # buildInputs
  fontconfig,
  openssl,
  apple-sdk_15,
  darwinMinVersionHook,

  redis,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "golem";
  version = "1.0.27";

  src = fetchFromGitHub {
    owner = "golemcloud";
    repo = "golem";
    tag = "v${version}";
    hash = "sha256-H8Dykn079107gZTV2w/T/gyIVxJtV8NuhuCM2+46yyI=";
  };

  # Taker from https://github.com/golemcloud/golem/blob/v1.0.26/Makefile.toml#L399
  postPatch = ''
    grep -rl --include 'Cargo.toml' '0\.0\.0' | xargs sed -i "s/0\.0\.0/${version}/g"
  '';

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      fontconfig
      (lib.getDev openssl)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_15
      # aws-lc-sys requires CryptoKit's CommonCrypto, which is available on macOS 10.15+
      (darwinMinVersionHook "10.15")
    ];

  # Required for golem-wasm-rpc's build.rs to find the required protobuf files
  # https://github.com/golemcloud/wasm-rpc/blob/v1.0.6/wasm-rpc/build.rs#L7
  GOLEM_WASM_AST_ROOT = "../golem-wasm-ast-1.0.1";
  # Required for golem-examples's build.rs to find the required Wasm Interface Type (WIT) files
  # https://github.com/golemcloud/golem-examples/blob/v1.0.6/build.rs#L9
  GOLEM_WIT_ROOT = "../golem-wit-1.0.3";

  useFetchCargoVendor = true;
  cargoHash = "sha256-GrZhWcm7id8pRrwHRDt5k1tcVnoePO8eCWCHzkhCsZk=";

  # Tests are failing in the sandbox because of some redis integration tests
  doCheck = false;
  checkInputs = [ redis ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = [ "${placeholder "out"}/bin/golem-cli" ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open source durable computing platform that makes it easy to build and deploy highly reliable distributed systems";
    changelog = "https://github.com/golemcloud/golem/releases/tag/v${version}";
    homepage = "https://www.golem.cloud/";
    license = lib.licenses.asl20;
    mainProgram = "golem-cli";
  };
}
