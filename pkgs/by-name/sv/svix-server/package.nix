{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  protobuf,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "svix-server";
  version = "1.62.0";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${version}";
    hash = "sha256-ft08skfLASgfZo3lrlN+nuF2FK78kEm2geRVg8cO5hM=";
  };

  sourceRoot = "${src.name}/server";

  useFetchCargoVendor = true;
  cargoHash = "sha256-0GuTIGWGeP7CG+CijjlRW9SPKfp7rPuZVuClLZC25dk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
      protobuf
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  OPENSSL_NO_VENDOR = 1;

  # disable tests because they require postgres and redis to be running
  doCheck = false;

  meta = with lib; {
    mainProgram = "svix-server";
    description = "Enterprise-ready webhooks service";
    homepage = "https://github.com/svix/svix-webhooks";
    changelog = "https://github.com/svix/svix-webhooks/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
    broken = stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin; # aws-lc-sys currently broken on darwin x86_64
  };
}
