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
  version = "1.64.1";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${version}";
    hash = "sha256-ZaSUTGv/l54tKvXd2hUeQYKTUmQOUm2dpZE7J8auWb0=";
  };

  sourceRoot = "${src.name}/server";

  useFetchCargoVendor = true;
  cargoHash = "sha256-h19xpILPudOMSC99wBB1CA/981eK+FHgsGJAJOFPeuw=";

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
