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
  version = "1.86.0";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kpk9jQPG13K54k/Rgcw7Cre2PEWjnoU/7meT9NlalT0=";
  };

  sourceRoot = "${finalAttrs.src.name}/server";

  cargoHash = "sha256-Eyl3yk+E/FXIlt/O5HPGxZxm+FffQ6pt+h5cj7r4L8M=";

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
