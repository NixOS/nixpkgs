{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "boringtun";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "boringtun";
    tag = "boringtun-${finalAttrs.version}";
    hash = "sha256-QrgKO0SVU4Z9GlNtZZmOV+Xcm1PonzLbUTGAFFOV/BM=";
  };

  cargoHash = "sha256-j1I16QC46MMxcK7rbZJgI8KiKJvF29hkuGKiYLc6uW0=";

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
