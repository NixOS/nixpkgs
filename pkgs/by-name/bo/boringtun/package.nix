{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "boringtun";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "boringtun-cli-${version}";
    sha256 = "sha256-PY7yqBNR4CYh8Y/vk4TYxxJnnv0eig8sjXp4dR4CX04=";
  };

  cargoHash = "sha256-WFKlfuZGVU5KA57ZYjsIrIwE4B5TeaU5IKt9BNEnWyY=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Security;

  # Testing this project requires sudo, Docker and network access, etc.
  doCheck = false;

  meta = {
    description = "Userspace WireGuard® implementation in Rust";
    homepage = "https://github.com/cloudflare/boringtun";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ xrelkd ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "boringtun-cli";
  };
}
