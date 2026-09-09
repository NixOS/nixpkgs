{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "boringtun";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "boringtun";
    tag = "boringtun-${finalAttrs.version}";
    hash = "sha256-IilQNWcN4cyTRiHppQzFxLPZvz0ep4nrvCrP2FWXerM=";
  };

  cargoHash = "sha256-Sm46l+/6QBa54PdTCNcWltRM9bMkzASYbEvuKsM6zHk=";

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
})
