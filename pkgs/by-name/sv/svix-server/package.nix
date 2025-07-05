{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  protobuf,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "svix-server";
  version = "1.68.0";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${version}";
    hash = "sha256-AiMaYSLON4H39dUvRyXQDymE/SQ7gK9JrgXBc1Gn7no=";
  };

  sourceRoot = "${src.name}/server";

  useFetchCargoVendor = true;
  cargoHash = "sha256-wNaI5/AtStekJslO8wDl1/PzHaEi02xBEO8IvcqbMZM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    protobuf
  ];

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  OPENSSL_NO_VENDOR = 1;

  # disable tests because they require postgres and redis to be running
  doCheck = false;

  meta = {
    mainProgram = "svix-server";
    description = "Enterprise-ready webhooks service";
    homepage = "https://github.com/svix/svix-webhooks";
    changelog = "https://github.com/svix/svix-webhooks/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ techknowlogick ];
    broken = stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin; # aws-lc-sys currently broken on darwin x86_64
  };
}
