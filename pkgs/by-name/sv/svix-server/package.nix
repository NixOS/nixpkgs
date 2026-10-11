{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  protobuf,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "svix-server";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JjCaDFOBUnTEAZhcL31pu4/+e7yqN6Pm5cikG2nRFTY=";
  };

  sourceRoot = "${finalAttrs.src.name}/server";

  cargoHash = "sha256-dJJPWxzYc8bMeiBleUZYB1yQ5+5o8l2hr5wPzQ6nUUI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    protobuf
  ];

  env = {
    # needed for internal protobuf c wrapper library
    PROTOC = "${protobuf}/bin/protoc";
    PROTOC_INCLUDE = "${protobuf}/include";

    OPENSSL_NO_VENDOR = 1;
  };

  # disable tests because they require postgres and redis to be running
  doCheck = false;

  meta = {
    mainProgram = "svix-server";
    description = "Enterprise-ready webhooks service";
    homepage = "https://github.com/svix/svix-webhooks";
    changelog = "https://github.com/svix/svix-webhooks/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ techknowlogick ];
    broken = stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin; # aws-lc-sys currently broken on darwin x86_64
  };
})
