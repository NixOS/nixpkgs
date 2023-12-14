{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, protobuf, stdenv
, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "svix-server";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${version}";
    hash = "sha256-6758ej7bTvwZPWifl239rQMazM8uw+Y4+3EbjE8XsTg=";
  };

  sourceRoot = "source/server";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "aide-0.10.0" = "sha256-hUUer5D6OA4F0Co3JgygY3g89cKIChFest67ABIX+4M=";
      "hyper-0.14.23" = "sha256-7MBCAjKYCdDbqCmYg3eYE74h7K7yTjfVoo0sjxr4g/s=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    protobuf
  ] ++ lib.optionals stdenv.isDarwin [
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
    description = "The enterprise-ready webhooks service";
    homepage = "https://github.com/svix/svix-webhooks";
    changelog =
      "https://github.com/svix/svix-webhooks/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
