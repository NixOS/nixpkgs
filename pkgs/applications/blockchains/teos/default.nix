{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  rustfmt,
  stdenv,
  darwin,
  pkg-config,
  openssl,
}:

let
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "talaia-labs";
    repo = "rust-teos";
    rev = "v${version}";
    hash = "sha256-UrzH9xmhVq12TcSUQ1AihCG1sNGcy/N8LDsZINVKFkY=";
  };

  meta = with lib; {
    homepage = "https://github.com/talaia-labs/rust-teos";
    license = licenses.mit;
    maintainers = with maintainers; [ seberm ];
  };
  updateScript = ./update.sh;
in
{
  teos = rustPlatform.buildRustPackage {
    pname = "teos";
    inherit version src;

    useFetchCargoVendor = true;
    cargoHash = "sha256-lod5I94T4wGwXEDtvh2AyaDYM0byCfaSBP8emKV7+3M=";

    buildAndTestSubdir = "teos";

    nativeBuildInputs = [
      protobuf
      rustfmt
    ];

    buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

    passthru.updateScript = updateScript;

    __darwinAllowLocalNetworking = true;

    meta = meta // {
      description = "Lightning watchtower compliant with BOLT13, written in Rust";
    };
  };

  teos-watchtower-plugin = rustPlatform.buildRustPackage {
    pname = "teos-watchtower-plugin";
    inherit version src;

    useFetchCargoVendor = true;
    cargoHash = "sha256-lod5I94T4wGwXEDtvh2AyaDYM0byCfaSBP8emKV7+3M=";

    buildAndTestSubdir = "watchtower-plugin";

    nativeBuildInputs = [
      pkg-config
      protobuf
      rustfmt
    ];

    buildInputs =
      [
        openssl
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        darwin.apple_sdk.frameworks.SystemConfiguration
      ];

    passthru.updateScript = updateScript;

    __darwinAllowLocalNetworking = true;

    meta = meta // {
      description = "Lightning watchtower plugin for clightning";
      mainProgram = "watchtower-client";
    };
  };
}
