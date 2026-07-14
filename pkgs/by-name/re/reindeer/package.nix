{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reindeer";
  version = "2026.07.06.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fGGssXTktQiJ5iW9XiaVVmizJfEpuE9TGeYfE5kYpCQ=";
  };

  patches = [
    # increase_nofile_limit caps at kern.maxfilesperproc on macOS,
    # which can be lower than an already-raised soft limit (a-la nix).
    # we restore the OG limit
    ./fix-rlimit-lowering.patch
  ];

  cargoHash = "sha256-Gti6H0TN211d7OAqEQcGaC/awBrAix5g+zUOFqKermI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ amaanq ];
  };
})
