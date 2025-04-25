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
  pname = "svix-cli";
  version = "1.58.1";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${version}";
    hash = "sha256-XDatrXFaDav0ucW19A7ALCRRCERCSey1wVXeVHGUV3M=";
  };

  sourceRoot = "${src.name}/svix-cli";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src sourceRoot;
    name = "svix-cli-${version}";
    hash = "sha256-AuIjP+UdmE26qJqGE/kVx5okM4j9dXw6k85PQx2RObU=";
  };

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

  meta = with lib; {
    mainProgram = "svix";
    description = "A CLI for interacting with the Svix API";
    homepage = "https://github.com/svix/svix-webhooks";
    changelog = "https://github.com/svix/svix-webhooks/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
    broken = stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin; # aws-lc-sys currently broken on darwin x86_64
  };
}
